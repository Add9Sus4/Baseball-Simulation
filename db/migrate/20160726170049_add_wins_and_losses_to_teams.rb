class AddWinsAndLossesToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :wins, :integer
    add_column :teams, :losses, :integer
  end
end
