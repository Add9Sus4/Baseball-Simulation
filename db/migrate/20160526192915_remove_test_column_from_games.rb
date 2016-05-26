class RemoveTestColumnFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :test
  end
end
