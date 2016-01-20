class AddPowerContactSpeedPatiencePlateVisionPullAmountUppercutAmountBattingAverageToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :power, :integer, :default => 50
    add_column :players, :contact, :integer, :default => 50
    add_column :players, :speed, :integer, :default => 50
    add_column :players, :patience, :integer, :default => 50
    add_column :players, :plateVision, :integer, :default => 50
    add_column :players, :pullAmount, :integer, :default => 50
    add_column :players, :uppercutAmount, :integer, :default => 50
    add_column :players, :battingAverage, :integer, :default => 50
  end
end
