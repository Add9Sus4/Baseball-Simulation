class AddPbpToGames < ActiveRecord::Migration
  def change
    add_column :games, :pbp, :text
  end
end
