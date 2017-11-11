class RenameCurrentFatigueToCurrentEnergyInPlayers < ActiveRecord::Migration
  def change
    rename_column :players, :current_fatigue, :current_energy
  end
end
