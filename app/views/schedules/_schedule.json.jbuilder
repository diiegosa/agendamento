json.extract! schedule, :id, :client_name, :client_cpf, :property_sequential, :email, :cellphone_number, :service_id, :service_point_id, :date, :time, :descrition, :created_at, :updated_at
json.url schedule_url(schedule, format: :json)
