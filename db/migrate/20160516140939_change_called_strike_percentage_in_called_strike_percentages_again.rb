class ChangeCalledStrikePercentageInCalledStrikePercentagesAgain < ActiveRecord::Migration
  def up
    # change_column :called_strike_percentages, :called_strike_percentage, :double
  end

  def down
    # change_column :called_strike_percentages, :called_strike_percentage, :decimal
  end
end
