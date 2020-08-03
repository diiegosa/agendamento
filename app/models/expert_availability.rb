class ExpertAvailability < ApplicationRecord
  belongs_to :expert
  has_many :schedules, as: :avaliable
  validates :expert, :shift, :date, presence: true
  validates :date, uniqueness: {scope: [:expert, :shift], message: "- Especialista e Turno já estão em uso" }
  scope :future, -> { where("date > ? AND date <= ?", Date.today, Date.today.next_month) }
  Required_field = 'é um campo obrigatório'

  ransacker :date, type: :date do
    Arel.sql('date::date')
  end

  def self.get_available_dates_by_expert(expert_id)
    where(expert_id: expert_id).future.select('date').limit(10).distinct
  end

  def self.validate(params)
    error = Hash.new
    error[:expert_id] = Required_field if params[:expert_availability][:expert_id].blank?
    error[:shift] = Required_field if params[:expert_availability][:shift].blank?
    error[:initial_date] = Required_field if params[:initial_date].blank?
    error[:final_date] = Required_field if params[:final_date].blank?

    error
  end

  def self.create(params)
    warning_array = Array.new
    days = (((Time.parse(params['final_date']) - Time.parse(params['initial_date'])) / 3600) / 24)

    for i in 0..days.to_i
      params['expert_availability']['shift'].each do |shift|
        date = Time.parse(params['initial_date']) + i.days

        expert_availability_already_created = ExpertAvailability.where(
              expert_id: params[:expert_availability][:expert_id],
              date: date,
              shift: shift
          )

        unless expert_availability_already_created.empty?
          expert_name = Expert.find(params[:expert_availability][:expert_id]).name
          warning_array.push("#{expert_name}, #{params['initial_date']}, TURNO: #{shift}")
          next
        end

        expert_availability = new(
          {
            expert_id: params[:expert_availability][:expert_id],
            date: date,
            shift: shift
          }
        )
        expert_availability.save
      end
    end

    warning_array
  end

  def self.get_expert_available_times_by_date(date)
    expert_availabilities = where(date: date).order(:shift)
    times = Availability.mount_time_array(expert_availabilities)

    # retirando os horários que já foram agendados do array que foi montado acima
    schedules = Schedule.scheduling_amount_by_time_only_expert(expert_availabilities.first.date)
    times_that_need_to_be_excluded = []
    times.each do |time|
      schedules.each do |schedule|
        times_that_need_to_be_excluded.push(time) if (schedule.time.strftime("%H:%M") == time)
      end
    end

    times - times_that_need_to_be_excluded
  end

  def self.get_services_availabilities()
    service_id_array = Array.new
    future.distinct.map { |e| e.expert.services }.each do |services|
      services.each do |service|
        service_id_array.push(service.id) unless service_id_array.include?(service.id)
      end
    end
    service_id_array
	end
end
