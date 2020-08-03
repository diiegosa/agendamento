json.extract! service_point, :id, :name, :acronym, :city, :neighborhood, :public_area, :cep, :number, :created_at, :updated_at
json.url service_point_url(service_point, format: :json)
