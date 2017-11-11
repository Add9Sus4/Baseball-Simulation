class AddCurrentFatigueToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :current_fatigue, :integer
  end
end
