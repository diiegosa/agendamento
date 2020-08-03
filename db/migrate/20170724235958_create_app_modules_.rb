class CreateAppModules < ActiveRecord::Migration[5.1]
  def change
    create_table :app_modules do |t|
      t.string :module
      t.string :controller
      t.json :actions
      t.timestamps
    end
  end
end
