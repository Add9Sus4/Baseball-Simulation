class CreateCalledStrikePercentages < ActiveRecord::Migration
  def change
    create_table :called_strike_percentages do |t|
      t.integer :zone_id
      t.decimal :called_strike_percentage
      t.string :pitcher_hand
      t.string :batter_hand
      t.integer :balls
      t.integer :strikes
      t.string :pitch_type
    end
  end
end
