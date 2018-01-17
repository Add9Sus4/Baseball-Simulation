class FixNamesOfPotentialAttributesInPlayers < ActiveRecord::Migration
  def change
    rename_column :players, :armStrength_potential, :arm_strength_potential
    rename_column :players, :fieldGrounder_potential, :field_grounder_potential
    rename_column :players, :fieldLiner_potential, :field_liner_potential
    rename_column :players, :fieldFlyball_potential, :field_flyball_potential
    rename_column :players, :fieldPopup_potential, :field_popup_potential
    rename_column :players, :throwShort_potential, :throw_short_potential
    rename_column :players, :throwMedium_potential, :throw_medium_potential
    rename_column :players, :throwLong_potential, :throw_long_potential
  end
end
