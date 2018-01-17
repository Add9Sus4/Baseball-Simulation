class AddRetiredToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :retired, :integer
  end
end
