class AddAtbatsToTests < ActiveRecord::Migration
  def change
    add_column :tests, :atbats, :integer
  end
end
