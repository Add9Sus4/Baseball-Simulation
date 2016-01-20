class AddAgilityReactionTimeArmStrengthFieldGrounderFieldLinerFieldFlyballFieldPopupThrowShortThrowMediumThrowLongIntelligenceEnduranceToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :agility, :integer, :default => 50
    add_column :players, :reactionTime, :integer, :default => 50
    add_column :players, :armStrength, :integer, :default => 50
    add_column :players, :fieldGrounder, :integer, :default => 50
    add_column :players, :fieldLiner, :integer, :default => 50
    add_column :players, :fieldFlyball, :integer, :default => 50
    add_column :players, :fieldPopup, :integer, :default => 50
    add_column :players, :throwShort, :integer, :default => 50
    add_column :players, :throwMedium, :integer, :default => 50
    add_column :players, :throwLong, :integer, :default => 50
    add_column :players, :intelligence, :integer, :default => 50
    add_column :players, :endurance, :integer, :default => 50
  end
end
