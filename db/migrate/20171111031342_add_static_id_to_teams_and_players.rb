class AddStaticIdToTeamsAndPlayers < ActiveRecord::Migration
  def change
    add_column :players, :static_id, :integer
    add_column :teams, :static_id, :integer
  end
end
