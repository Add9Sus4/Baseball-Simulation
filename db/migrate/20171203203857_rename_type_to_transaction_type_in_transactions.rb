class RenameTypeToTransactionTypeInTransactions < ActiveRecord::Migration
  def change
    rename_column :transactions, :type, :transaction_type
  end
end
