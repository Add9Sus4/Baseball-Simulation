class AddMovementControlLocationToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :movement, :integer, :default => 50
    add_column :players, :control, :integer, :default => 50
    add_column :players, :location, :integer, :default => 50
  end
end
