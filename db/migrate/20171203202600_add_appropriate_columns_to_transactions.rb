class AddAppropriateColumnsToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :team_id, :integer
    add_column :transactions, :type, :text
    add_column :transactions, :promoted_player_id, :integer
    add_column :transactions, :dropped_player_id, :integer
    add_column :transactions, :signed_player_id, :integer
    add_column :transactions, :drafted_player_id, :integer
  end
end
