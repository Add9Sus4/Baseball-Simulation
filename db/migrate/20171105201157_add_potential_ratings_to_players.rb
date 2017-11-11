class AddPotentialRatingsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :power_potential, :integer
    add_column :players, :contact_potential, :integer
    add_column :players, :speed_potential, :integer
    add_column :players, :patience_potential, :integer
    add_column :players, :plate_vision_potential, :integer
    add_column :players, :pull_amount_potential, :integer
    add_column :players, :uppercut_amount_potential, :integer
    add_column :players, :batting_average_potential, :integer
    add_column :players, :movement_potential, :integer
    add_column :players, :control_potential, :integer
    add_column :players, :location_potential, :integer
    add_column :players, :agility_potential, :integer
    add_column :players, :reaction_time_potential, :integer
    add_column :players, :armStrength_potential, :integer
    add_column :players, :fieldGrounder_potential, :integer
    add_column :players, :fieldLiner_potential, :integer
    add_column :players, :fieldFlyball_potential, :integer
    add_column :players, :fieldPopup_potential, :integer
    add_column :players, :throwShort_potential, :integer
    add_column :players, :throwMedium_potential, :integer
    add_column :players, :throwLong_potential, :integer
    add_column :players, :intelligence_potential, :integer
    add_column :players, :endurance_potential, :integer
  end
end
