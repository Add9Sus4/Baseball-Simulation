class AddDraftRoundAndPositionToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :draft_round, :integer
    add_column :players, :draft_position, :integer
  end
end
