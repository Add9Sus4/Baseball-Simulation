class AddAppropriateColumnsToSeasonAttributes < ActiveRecord::Migration
  def change
    add_column :season_attributes, :player_id, :integer
    add_column :season_attributes, :team_id, :integer
    add_column :season_attributes, :season_id, :integer
    add_column :season_attributes, :age, :integer
    add_column :season_attributes, :position, :text
    add_column :season_attributes, :salary, :integer
    add_column :season_attributes, :power, :integer
    add_column :season_attributes, :contact, :integer
    add_column :season_attributes, :speed, :integer
    add_column :season_attributes, :patience, :integer
    add_column :season_attributes, :plate_vision, :integer
    add_column :season_attributes, :pull_amount, :integer
    add_column :season_attributes, :uppercut_amount, :integer
    add_column :season_attributes, :batting_average, :integer
    add_column :season_attributes, :movement, :integer
    add_column :season_attributes, :control, :integer
    add_column :season_attributes, :location, :integer
    add_column :season_attributes, :agility, :integer
    add_column :season_attributes, :reaction_time, :integer
    add_column :season_attributes, :arm_strength, :integer
    add_column :season_attributes, :field_grounder, :integer
    add_column :season_attributes, :field_liner, :integer
    add_column :season_attributes, :field_popup, :integer
    add_column :season_attributes, :throw_short, :integer
    add_column :season_attributes, :throw_medium, :integer
    add_column :season_attributes, :throw_long, :integer
    add_column :season_attributes, :intelligence, :integer
    add_column :season_attributes, :endurance, :integer
    add_column :season_attributes, :clutch, :integer
  end
end
