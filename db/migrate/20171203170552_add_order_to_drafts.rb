class AddOrderToDrafts < ActiveRecord::Migration
  def change
    add_column :drafts, :order, :text
  end
end
