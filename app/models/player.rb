class Player < ActiveRecord::Base
  validates :team, :first_name, :last_name, :age, :height, :weight, :position, :salary, presence: true
  validates_numericality_of :weight, greater_than_or_equal_to: 160, less_than_or_equal_to: 300
  validate :team_cannot_have_more_than_max_players
  belongs_to :team

  def team_cannot_have_more_than_max_players
    team = Team.find(team_id);
    totalPlayers = team.players.length

    if totalPlayers >= Team::MAX_PLAYERS
      errors.add(:base, "The " + team.city + " " + team.name + " already have the maximum number of players allowed(" + Team::MAX_PLAYERS.to_s + ").")
    end
  end


  def full_name
    first_name + ' ' + last_name
  end

  def average_fielding
    (fieldGrounder + fieldLiner + fieldFlyball + fieldPopup)/4
  end

  def average_throwing
    (throwShort + throwMedium + throwLong)/3
  end

  def to_s
    full_name
  end

end
