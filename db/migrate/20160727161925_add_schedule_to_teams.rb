class AddScheduleToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :schedule, :text
  end
end
