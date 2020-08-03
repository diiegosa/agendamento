class Schedule < ApplicationRecord
  belongs_to :service
  belongs_to :service_point
  belongs_to :avaliable, polymorphic: true
  validates :client_name, :client_cpf, :client_email, :client_email_confirmation, :client_cellphone_number, presence: true
  validates :service, :service_point, :date, :time, :property_sequential_or_protocol, presence: true
  validates :client_email, confirmation: true
  validates_cpf :client_cpf
  validates :client_cellphone_number, numericality: true, length: { minimum: 10, maximum: 11 }
  before_create :check_if_datetime_is_free, :set_sga_token, :set_sga_status
  after_create :set_protocol
  scope :without_expert, -> { where(avaliable_type: Availability.model_name.to_s) }
  scope :only_expert, -> { where(avaliable_type: ExpertAvailability.model_name.to_s) }
  attribute :is_expert_service, :boolean

  ransacker :date, type: :date do
    Arel.sql('date::date')
  end

  def self.send_information_by_email(schedule_id)
    begin
      schedule = Schedule.find(schedule_id)
      ReceiptMailer.schedule_email(schedule).deliver
      {success: "Informações sobre o agendamento de #{schedule.get_pt_br_datetime} enviadas ao email: #{schedule.client_email}"}
    rescue => exception
      {error: "Agendamento não encontrado"}
    end
  end

  def self.cancel(schedule_protocol, id)
    schedule = Schedule.where({id: id, schedule_protocol: schedule_protocol}).first
    return {error: "Protocolo: '#{schedule_protocol}' não está relacionado a este agendamento"} if schedule.nil?
    schedule.sga_status = NovoSga::Attendance::STATUS[:cancel]
    schedule.update_attribute(:sga_status, NovoSga::Attendance::STATUS[:cancel])
    ReceiptMailer.schedule_cancel(schedule).deliver
    {success: "Agendamento de #{schedule.get_pt_br_datetime} foi cancelado com sucesso"}
  end

  def self.get_by_email(email)
    return {list: [], error: "O campo email precisa ser preenchido!"} if email.empty?

    schedules = Schedule.where({client_email: email, sga_status: NovoSga::Attendance::STATUS[:emit]}).where("date >= ?", Date.today).map do |schedule|
      {
        client_name: schedule.client_name,
        service_name: schedule.service.name,
        local: schedule.service_point.name,
        client_email: schedule.client_email,
        datetime: schedule.get_pt_br_datetime,
        id: schedule.id
      }
    end

    return {list: [], error: "Nenhum agendamento cadastrado referente ao email informado!"} if (schedules.empty?)

    return {list: schedules, error: nil}
  end

  def client_name=(client_name)
    write_attribute(:client_name, client_name.upcase)
  end

  def client_email=(client_email)
    write_attribute(:client_email, client_email.downcase.strip)
  end

  def client_cpf=(client_cpf)
    write_attribute(:client_cpf, client_cpf.remove(".","-"))
  end

  def client_cellphone_number=(client_cellphone_number)
    write_attribute(:client_cellphone_number, client_cellphone_number.remove("(",")","-"," "))
  end

  def description=(description)
    write_attribute(:description, description.upcase)
  end

  def get_sga_token
    self.sga_token_initials + self.sga_token_number
  end

  def has_expert?
    !self.service.experts.empty?
  end

  def get_expert_name
    self.avaliable.expert.name
  end

  def self.scheduling_amount_by_time_without_expert(availability_date)
    select("time").without_expert.where({date: availability_date, sga_status: NovoSga::Attendance::STATUS[:emit]}).group(:time).count(:time)
  end

  def self.scheduling_amount_by_time_only_expert(availability_date)
    select("time").only_expert.where({date: availability_date, sga_status: NovoSga::Attendance::STATUS[:emit]})
  end

  def get_datetime
    (self.date.to_s + " " + self.time.to_s).to_datetime
  end

  def get_pt_br_datetime
    (self.date.to_s + " " + self.time.to_s).to_datetime.strftime('%d/%m/%Y %H:%M')
  end

  def get_novo_sga_service_point_id
    self.service_point.novo_sga_service_point.id
  end

  def get_novo_sga_service_id
    self.service.novo_sga_service.id
  end

  def self.get_today
    where(date: Date.today).where('time >= ?', Time.now.strftime("%H:%M")).order(:time)
  end

  def set_protocol
    self.schedule_protocol = Time.now.strftime("%M%S").to_s + id.to_s
    save
  end

  def self.generate_object(schedule_params, total_params)
    is_expert_service = total_params[:schedule].include?(:expert_id)
    schedule_params[:service_point_id] = Expert.find(total_params[:schedule][:expert_id]).service_point.id if is_expert_service
    schedule = Schedule.new(schedule_params)
    schedule.is_expert_service = is_expert_service
    schedule.check_availability

    schedule
  end

  def check_availability
    availability = self.is_expert_service ? ExpertAvailability.where(date: self.date, shift: Schedule.get_shift(self.time.strftime("%H:%M")))
      : Availability.where(service_point_id: self.service_point_id, service_id: self.service_id, date: self.date, shift: Schedule.get_shift(self.time.strftime("%H:%M")))

    errors.add(:base, "Erro: Não há disponibilidade para essa data/hora") if availability.empty?

    self.avaliable = availability.first
  end

  def check_if_datetime_is_free
    schedules = Schedule.where(service_id: self.service_id, service_point_id: self.service_point_id,
      date: self.date, time: self.time.strftime("%H:%M"), sga_status: NovoSga::Attendance::STATUS[:emit] )

    if (!schedules.empty? && schedules.length >= schedules.first.avaliable.attendant_number)
      errors.add(:base, "Erro: Alguém agendou nessa data/hora antes de você")
      throw :abort
    end
  end

  def set_sga_token
    self.sga_token_number = (Schedule.where({date: date, service_id: service_id, service_point_id: service_point_id}).count) + 1
    self.sga_token_initials = Service.find(service_id).novo_sga_service.get_initials(ServicePoint.find(service_point_id).novo_sga_service_point.id)
  end

  def set_sga_status
    self.sga_status =  NovoSga::Attendance::STATUS[:emit]
  end

  def self.get_shift(time)
    time < "12:00" ? 1 : 2
  end

end
