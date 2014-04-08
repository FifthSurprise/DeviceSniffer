class AddUpdatesToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :updates, :integer, default: 0
  end
end
