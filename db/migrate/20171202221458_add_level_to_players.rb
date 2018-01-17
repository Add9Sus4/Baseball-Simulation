class AddLevelToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :level, :text
  end
end
