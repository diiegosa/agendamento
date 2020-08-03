class AddTokenNumberAndInitialsToSchedules < ActiveRecord::Migration[5.1]
  def change
    add_column :schedules, :token_number, :string, null: true
    add_column :schedules, :initials, :string, null: true
  end
end
