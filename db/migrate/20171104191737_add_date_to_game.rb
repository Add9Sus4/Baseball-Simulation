class AddDateToGame < ActiveRecord::Migration
  def change
    add_column :games, :sim_date, :date
  end
end
