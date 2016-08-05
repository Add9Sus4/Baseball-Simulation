class AddRotationToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :rotation_position, :integer
  end
end
