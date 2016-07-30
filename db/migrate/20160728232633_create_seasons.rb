class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.integer :next_game

      t.timestamps null: false
    end
  end
end
