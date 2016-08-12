class AddSimulatingToSeasons < ActiveRecord::Migration
  def change
    add_column :seasons, :simulating, :integer
  end
end
