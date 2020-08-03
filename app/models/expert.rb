class Expert < ApplicationRecord
    validates :name, :service_point_id, presence: true
    has_and_belongs_to_many :services
    has_many :expert_availabilities
    belongs_to :service_point

    def name=(name)
  		write_attribute(:name, name.upcase)
	end

    def self.get_all_that_have_availability_by_service(service_id)
        id_name_experts_array = Array.new
        experts = Service.experts_by_service(service_id)
        experts.each do |expert|
            expert.expert_availabilities.each do |expert_availability|
                if(expert_availability.date > Date.today)
                    id_name_experts_array.push({id: expert.id, name: expert.name})
                    break
                end
            end
        end
        id_name_experts_array
    end
end
