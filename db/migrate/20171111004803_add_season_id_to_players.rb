class AddSeasonIdToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :season_id, :integer
  end
end
