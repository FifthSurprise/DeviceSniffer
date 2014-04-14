class AddIndexToDevices < ActiveRecord::Migration
  def change
    add_index(:devices, "macaddress")
  end
end
