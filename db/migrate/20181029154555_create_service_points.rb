class CreateServicePoints < ActiveRecord::Migration[5.1]
  def change
    create_table :service_points do |t|
      t.integer :novo_sga_service_point_id, index: {unique: true}
      t.string :city
      t.string :neighborhood
      t.string :public_area
      t.string :cep
      t.string :number

      t.timestamps
    end
  end
end
