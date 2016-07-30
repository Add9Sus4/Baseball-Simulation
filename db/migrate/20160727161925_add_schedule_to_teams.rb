class AddScheduleToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :schedule, :longtext
  end
end
