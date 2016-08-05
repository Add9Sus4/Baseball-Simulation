class AddPitchingAssignmentsToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :sp1, :integer
    add_column :teams, :sp2, :integer
    add_column :teams, :sp3, :integer
    add_column :teams, :sp4, :integer
    add_column :teams, :sp5, :integer
    add_column :teams, :lr, :integer
    add_column :teams, :mr1, :integer
    add_column :teams, :mr2, :integer
    add_column :teams, :mr3, :integer
    add_column :teams, :su1, :integer
    add_column :teams, :su2, :integer
    add_column :teams, :cl, :integer
  end
end
