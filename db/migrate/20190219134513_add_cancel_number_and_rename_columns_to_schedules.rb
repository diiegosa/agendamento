class AddCancelNumberAndRenameColumnsToSchedules < ActiveRecord::Migration[5.1]
  def change
    rename_column :schedules, :token_number, :sga_token_number
    rename_column :schedules, :initials, :sga_token_initials
    add_column :schedules, :cancel_protocol_number, :integer
  end
end
