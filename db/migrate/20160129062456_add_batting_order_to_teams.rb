class AddBattingOrderToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :lineup1, :integer
    add_column :teams, :lineup2, :integer
    add_column :teams, :lineup3, :integer
    add_column :teams, :lineup4, :integer
    add_column :teams, :lineup5, :integer
    add_column :teams, :lineup6, :integer
    add_column :teams, :lineup7, :integer
    add_column :teams, :lineup8, :integer
    add_column :teams, :lineup9, :integer
  end
end
