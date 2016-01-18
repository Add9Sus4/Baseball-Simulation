class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :city
      t.string :name
      t.string :league
      t.string :division
      t.string :stadium
      t.integer :capacity

      t.timestamps null: false
    end
  end
end
