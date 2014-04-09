class AddManufacturerToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :company, :string
  end
end
