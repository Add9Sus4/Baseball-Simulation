class AddCurrentDateToSeason < ActiveRecord::Migration
  def change
    add_column :seasons, :current_date, :date
  end
end
