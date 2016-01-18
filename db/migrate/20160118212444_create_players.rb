class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :team_id
      t.string :first_name
      t.string :last_name
      t.integer :age
      t.integer :height
      t.integer :weight
      t.string :position
      t.integer :salary

      t.timestamps null: false
    end
  end
end
