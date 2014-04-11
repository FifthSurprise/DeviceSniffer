class ChangeColumnForMovements < ActiveRecord::Migration
  def change

    change_column :movements, :velocity, :string

  end
end
