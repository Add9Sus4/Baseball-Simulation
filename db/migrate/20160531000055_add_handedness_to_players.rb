class AddHandednessToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :throwing_hand, :string
    add_column :players, :hitting_side, :string
  end
end
