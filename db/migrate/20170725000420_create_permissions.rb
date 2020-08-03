class CreatePermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :permissions, {:id => false} do |t|
      t.references :profile, foreign_key: true
      t.references :app_module, foreign_key: true
      t.json :actions
    end
    add_index :permissions, ["profile_id", "app_module_id"], :unique => true
  end
end
