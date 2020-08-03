class CreateServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
      t.integer :novo_sga_service_id, index: {unique: true}
      t.text :document
      t.timestamps
    end
  end
end
