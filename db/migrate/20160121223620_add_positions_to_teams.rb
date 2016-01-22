class AddPositionsToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :catcher_id, :integer
    add_column :teams, :designated_hitter_id, :integer
    add_column :teams, :first_base_id, :integer
    add_column :teams, :second_base_id, :integer
    add_column :teams, :third_base_id, :integer
    add_column :teams, :shortstop_id, :integer
    add_column :teams, :left_field_id, :integer
    add_column :teams, :center_field_id, :integer
    add_column :teams, :right_field_id, :integer
    add_column :teams, :bench1_id, :integer
    add_column :teams, :bench2_id, :integer
    add_column :teams, :bench3_id, :integer
    add_column :teams, :bench4_id, :integer
  end
end
