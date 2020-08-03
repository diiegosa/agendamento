class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.string :client_name
      t.string :client_cpf
      t.string :client_email
      t.string :client_cellphone_number
      t.string :property_sequential_or_protocol
      t.date :date
      t.time :time
      t.text :description
      t.string :schedule_protocol
      t.references :service, foreign_key: true
      t.references :service_point, foreign_key: true

      t.references :avaliable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
