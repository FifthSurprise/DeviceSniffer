class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.string :macaddress
      t.integer :velocity
      t.timestamps
    end
  end
end
