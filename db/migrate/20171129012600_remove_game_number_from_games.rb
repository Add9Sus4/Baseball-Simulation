class RemoveGameNumberFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :game_number
  end
end
