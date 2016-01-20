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
      t.integer :power
      t.integer :contact
      t.integer :speed
      t.integer :patience
      t.integer :plate_vision
      t.integer :pull_amount
      t.integer :uppercut_amount
      t.integer :batting_average
      t.integer :movement
      t.integer :control
      t.integer :location
      t.integer :agility
      t.integer :reactionTime
      t.integer :armStrength
      t.integer :fieldGrounder
      t.integer :fieldLiner
      t.integer :fieldFlyball
      t.integer :fieldPopup
      t.integer :throwShort
      t.integer :throwMedium
      t.integer :throwLong
      t.integer :intelligence
      t.integer :endurance

      t.timestamps null: false
    end
  end
end
