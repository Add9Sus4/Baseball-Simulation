class AddPitchTypesToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :pitch_1, :string
    add_column :players, :pitch_2, :string
    add_column :players, :pitch_3, :string
    add_column :players, :pitch_4, :string
    add_column :players, :pitch_5, :string
  end
end
