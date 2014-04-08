class ChangeDefaultForUpdates < ActiveRecord::Migration
  def change
    change_column :devices, :updates, :integer, :default => 1
  end
end
