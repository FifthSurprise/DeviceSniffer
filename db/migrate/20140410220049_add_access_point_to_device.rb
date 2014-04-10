class AddAccessPointToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :accesspoint, :string
  end
end
