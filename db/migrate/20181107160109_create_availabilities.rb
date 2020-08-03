class CreateAvailabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :availabilities do |t|
      t.belongs_to :service_point, foreign_key: true
      t.belongs_to :service, foreign_key: true
      t.date :date
      t.integer :shift
      t.integer :attendant_number

      t.timestamps
    end
  end
end
