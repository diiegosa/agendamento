class AddNovoSgaStatusToSchedules < ActiveRecord::Migration[5.1]
  def change
    add_column :schedules, :sga_status, :string
  end
end
