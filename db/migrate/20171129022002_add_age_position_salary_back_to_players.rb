class AddAgePositionSalaryBackToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :age, :integer
    add_column :players, :position, :text
    add_column :players, :salary, :integer
  end
end
