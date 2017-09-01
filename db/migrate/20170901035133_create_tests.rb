class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :attribute
      t.integer :singles
      t.integer :doubles
      t.integer :triples
      t.integer :homers
      t.integer :walks
      t.integer :strikeouts

      t.timestamps null: false
    end
  end
end
