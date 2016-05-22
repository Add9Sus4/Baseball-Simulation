class CreatePitchLocations < ActiveRecord::Migration
  def change
    create_table :pitch_locations do |t|
      t.integer :zone_id
      t.decimal :pitch_percentage
      t.string :pitcher_hand
      t.string :batter_hand
      t.integer :balls
      t.integer :strikes
      t.string :pitch_type
    end
  end
end
