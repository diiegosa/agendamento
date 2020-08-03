class Availability < ApplicationRecord
  belongs_to :service_point
  belongs_to :service
  has_many :schedules, as: :avaliable
  validates :service_point, :service, :shift, :date, :attendant_number, presence: true
  validates :date, uniqueness: {scope: [:service_point, :service, :shift], message: "- Ponto de atendimento, Serviço e Turno já estão em uso" }
  scope :future, -> { where("date > ? AND date <= ?", Date.today, Date.today.next_month) }
  Required_field = 'é um campo obrigatório'

  ransacker :date, type: :date do
    Arel.sql('date::date')
  end

  def self.validate(params)
    error = Hash.new
    error[:service_point] = Required_field if params[:availability][:service_point] == '0'
    error[:service] = Required_field if !params[:availability][:service_ids]
    error[:shift] = Required_field if !params[:availability][:shift]
    error[:initial_date] = Required_field if params[:initial_date].empty?
    error[:final_date] = Required_field if params[:final_date].empty?
    error[:attendant_number] = Required_field if params[:attendant_number].empty?

    error
  end

  def self.create(params)
    warning_array = Array.new
    days = (((Time.parse(params['final_date']) - Time.parse(params['initial_date'])) / 3600) / 24)
    params['availability']['service_ids'].each do |service_id|
      for i in 0..days
        params['availability']['shift'].each do |shift|
          date = Time.parse(params['initial_date']) + i.days

          availability_already_created = Availability.where(
                    service_point_id: params['availability']['service_point'],
                    service_id: service_id,
                    date: date,
                    shift: shift
                  )

          unless availability_already_created.empty?
            service_point_name = ServicePoint.find(params['availability']['service_point']).name
            service_name = Service.find(service_id).name
            warning_array.push("#{service_point_name}, #{service_name}, #{params['initial_date']}, TURNO: #{shift}")
            next
          end

          availability = new(
            {
              'service_point_id' => params['availability']['service_point'],
              'service_id' => service_id,
              'date' => date,
              'shift' => shift,
              'attendant_number' => params['attendant_number']
            }
          )
          availability.save
        end
      end
    end
    warning_array
  end

  def self.get_available_dates_by_service_point_and_service(service_point_id, service_id)
    where(service_point_id: service_point_id).where(service_id: service_id).future.select('date').limit(10).distinct.order(:date)
  end

  def self.mount_time_array(availabilities)
    # montando um array com todos os horários possíveis por turno
    times = Array.new()
    starting_time = 28800 # começa às 08:00 o atendimento do turno 1
    closing_time = 42000 # termina às 12:00 o atendimento do turno 1
    availabilities.each do |availability|
      if (availability.shift == 2) #se for o segundo turno
        starting_time = 43200 # começa às 12:00 o atendimento do turno 2
        closing_time = 61200 # termina às 17:00 o atendimento do turno 2
      end

      begin
        times.push(Time.at(starting_time).utc.strftime("%H:%M"))
        starting_time += 1200 # acrescentando 20 minutos
      end while starting_time <= closing_time
    end
    times
  end

  def self.get_available_times_by_date(date)
    availabilities = where(date: date).order(:shift)
    times = self.mount_time_array(availabilities)

    # retirando os horários que já foram agendados do array que foi montado acima
    schedules = Schedule.scheduling_amount_by_time_without_expert(availabilities.first.date)
    times_that_need_to_be_excluded = []
    times.each do |time|
      shift = Schedule.get_shift(time) # para saber qual o turno
      schedules.each do |scheduled_time, scheduled_mount|
        times_that_need_to_be_excluded.push(time) if (scheduled_time.strftime("%H:%M") == time && scheduled_mount == availabilities.find_by(shift: shift).attendant_number)
      end
    end

    times - times_that_need_to_be_excluded
  end

  def self.get_service_points_availabilities_by_service(service_id)
		where(service_id: service_id).future.select('service_point_id').distinct.map { |e| e.service_point_id }
	end

  def self.get_services_availabilities()
		future.select('service_id').distinct.map { |e| e.service_id }
	end

end
