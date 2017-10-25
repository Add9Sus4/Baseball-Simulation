class AddCurrentPositionColumnToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :current_position, :text
  end
end
