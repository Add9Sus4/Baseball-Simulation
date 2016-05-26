class RemoveTestAndPbpColumnsFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :pbp, :test
    rename_column :games, :random_column, :play_by_play
  end
end
