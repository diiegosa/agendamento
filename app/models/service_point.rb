class ServicePoint < ApplicationRecord
	belongs_to :novo_sga_service_point, -> { where(deleted_at: nil) }, class_name: 'NovoSga::ServicePoint'
	has_many :availabilities
	validates :city, :neighborhood, :public_area, :number, presence: true

	def services
		Service.where(novo_sga_service_id:
			NovoSga::ServiceServicePoint.select(:servico_id).where(unidade_id: self.novo_sga_service_point_id).map { |service_service_point| service_service_point.servico_id }
		)
	end

	def name
		self.novo_sga_service_point.nome
	end

	def city=(city)
		write_attribute(:city, city.upcase)
	end

	def neighborhood=(neighborhood)
		write_attribute(:neighborhood, neighborhood.upcase)
	end

	def public_area=(public_area)
		write_attribute(:public_area, public_area.upcase)
	end

	def cep=(cep)
		write_attribute(:cep, cep.upcase)
	end

	def number=(number)
		write_attribute(:number, number.upcase)
	end

	def self.get_all_to_new_or_edit(service_point_id = nil)
        service_point_id_array = service_point_id.nil? ? self.select(:novo_sga_service_point_id).map(&:novo_sga_service_point_id)
            : self.select(:novo_sga_service_point_id).where.not(id: service_point_id).map(&:novo_sga_service_point_id)

        NovoSga::ServicePoint.where.not(id: service_point_id_array)
    end

	def self.get_all_id_and_name_services_without_expert(service_point_code)
		service_point = ServicePoint.find_by_id(service_point_code)
		return [] if (service_point.blank?)
		service_point.services.reject { |service| !service.experts.blank? }.map { |s| {id: s.id, name: s.name} }
	end

	def get_address
		"#{public_area}, #{number}. #{neighborhood}-#{city}."
	end

	def self.get_all_that_have_availability_by_service(service_id)
		find(Availability.get_service_points_availabilities_by_service(service_id)).map { |service_point| {id: service_point.id, name: service_point.name } }
	end

end
