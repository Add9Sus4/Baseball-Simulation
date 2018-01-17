class AddFieldFlyballToSeasonAttributes < ActiveRecord::Migration
  def change
    add_column :season_attributes, :field_flyball, :integer
  end
end
