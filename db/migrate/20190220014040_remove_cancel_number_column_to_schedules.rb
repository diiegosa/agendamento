class RemoveCancelNumberColumnToSchedules < ActiveRecord::Migration[5.1]
  def change
    remove_column :schedules, :cancel_protocol_number
  end
end
