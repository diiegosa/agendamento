class AddFaIconToService < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :fa_icon, :string
  end
end
