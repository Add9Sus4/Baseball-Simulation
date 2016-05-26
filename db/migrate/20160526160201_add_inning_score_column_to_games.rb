class AddInningScoreColumnToGames < ActiveRecord::Migration
  def change
    add_column :games, :home_inning_scores, :string
    add_column :games, :away_inning_scores, :string
  end
end
