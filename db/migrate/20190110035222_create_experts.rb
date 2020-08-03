class CreateExperts < ActiveRecord::Migration[5.1]
  def change
    create_table :experts do |t|
      t.string :name
      t.references :service_point, foreign_key: true
      t.timestamps
    end
  end
end
