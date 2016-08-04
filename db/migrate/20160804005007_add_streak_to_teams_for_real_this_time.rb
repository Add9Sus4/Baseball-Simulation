class AddStreakToTeamsForRealThisTime < ActiveRecord::Migration
  def change
    add_column :teams, :streak, :integer
  end
end
