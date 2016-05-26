class AddRandomTestColumnToGames < ActiveRecord::Migration
  def change
    add_column :games, :test, :string
  end
end
