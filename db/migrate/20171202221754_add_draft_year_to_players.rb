class AddDraftYearToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :draft_year, :integer
  end
end
