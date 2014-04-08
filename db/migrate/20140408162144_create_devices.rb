class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :macaddress
      t.string :rssi
      t.timestamps
    end
  end
end
