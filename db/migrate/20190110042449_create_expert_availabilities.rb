class CreateExpertAvailabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :expert_availabilities do |t|
      t.references :expert, foreign_key: true
      t.integer :shift
      t.date :date

      t.timestamps
    end
  end
end
