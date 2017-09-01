class RenameAttributeToNameForRealThisTime < ActiveRecord::Migration
  def change
    rename_column :tests, :attribute, :name
  end
end
