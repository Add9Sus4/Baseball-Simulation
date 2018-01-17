class AddYearToDrafts < ActiveRecord::Migration
  def change
    add_column :drafts, :year, :integer
  end
end
