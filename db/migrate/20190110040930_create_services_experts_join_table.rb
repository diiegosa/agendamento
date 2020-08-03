class CreateServicesExpertsJoinTable < ActiveRecord::Migration[5.1]
  def change
  	create_join_table :services, :experts
  end
end
