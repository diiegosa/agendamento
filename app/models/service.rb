class Service < ApplicationRecord
	belongs_to :novo_sga_service, -> { where(deleted_at: nil) }, class_name: 'NovoSga::Service'
	has_and_belongs_to_many :experts
	has_many :availabilities, through: :service_points
	validates :fa_icon, presence: true

	def document=(document)
  		write_attribute(:document, document.upcase)
	end

	def name
		self.novo_sga_service.nome.upcase
	end

	def fa_icon=(fa_icon)
		write_attribute(:fa_icon, fa_icon.downcase)
  	end

	def service_points
		ServicePoint.where(novo_sga_service_point_id:
			NovoSga::ServiceServicePoint.select(:unidade_id).where(servico_id: self.novo_sga_service_id).map { |service_service_point| service_service_point.unidade_id }
		)
	end

	def self.get_all_that_have_service_point
		find(Availability.get_services_availabilities | ExpertAvailability.get_services_availabilities).map { |service| {id: service.id, name: service.name, fa_icon: service.fa_icon }}
	end

	def self.get_all_to_new_or_edit(service_id = nil)
        service_id_array = service_id.nil? ? self.select(:novo_sga_service_id).map(&:novo_sga_service_id)
            : self.select(:novo_sga_service_id).where.not(id: service_id).map(&:novo_sga_service_id)
        NovoSga::Service.where.not(id: service_id_array)
    end

	def self.experts_by_service(service_id)
		find(service_id).experts
	end

	def self.all_without_service_point
		services = all
		return [] if services.blank?
		services.reject { |service| service.service_points.blank? }
    end

end
