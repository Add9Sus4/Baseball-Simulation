class AddAppropriateColumnsToAchievements < ActiveRecord::Migration
  def change
    add_column :achievements, :achievement_type, :text
    add_column :achievements, :player_id, :integer
    add_column :achievements, :team_id, :integer
    add_column :achievements, :game_id, :integer
    add_column :achievements, :achievement_date, :date
  end
end
