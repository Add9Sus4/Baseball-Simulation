class RemoveBenchFromTeams < ActiveRecord::Migration
  def change
    remove_column :teams, :bench1
    remove_column :teams, :bench2
    remove_column :teams, :bench3
    remove_column :teams, :bench4
  end
end
