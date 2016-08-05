class AddWinsAndLossesToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :wins, :integer
    add_column :players, :losses, :integer
  end
end
