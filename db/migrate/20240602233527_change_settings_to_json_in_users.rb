class ChangeSettingsToJsonInUsers < ActiveRecord::Migration[7.1]
  def up
    remove_column :users, :settings
    add_column :users, :settings, :json, default: {}
  end

  def down
    remove_column :users, :settings
    add_column :users, :settings, :text
  end
end
