class AddPitchZoneTrackerToPlayers < ActiveRecord::Migration
  def change
    for i in 1..72 do
    add_column :players, "zone_#{i}_pitches".to_sym, :integer
    end
  end
end
