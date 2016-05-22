class CreateContactPercentages < ActiveRecord::Migration
  def change
    create_table :contact_percentages do |t|
      t.integer :zone_id
      t.decimal :contact_percentage
      t.string :pitcher_hand
      t.string :batter_hand
      t.integer :balls
      t.integer :strikes
      t.string :pitch_type
    end
  end
end
