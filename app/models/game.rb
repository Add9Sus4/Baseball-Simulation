class Game < ActiveRecord::Base
  validate :teams_must_be_different

  def teams_must_be_different
    errors.add(:base, "Teams cannot be the same") if home_team_id == away_team_id
  end

  # Plays a game
  def play()
    prepare
  end

  # Creates instance variables to use in the game
  def prepare()

    # home and away teams
    @home_team = Team.find(self.home_team_id)
    @away_team = Team.find(self.away_team_id)

    # home and away players
    @home_players = []
    @away_players = []

    # put players on home team
    @home_team.players.each do |player|
      @home_players.push(player)
    end

    # put players on away team
    @away_team.players.each do |player|
      @away_players.push(player)
    end

    # heat map data
    @called_strike_percentages = CalledStrikePercentage.all
    @contact_percentages = ContactPercentage.all
    @pitch_locations = PitchLocation.all
    @swing_percentages = SwingPercentage.all

    # stadium data
    self.stadium_name = @home_team.stadium
    self.attendance = rand(30000..60000)

  end

  # Retrieve called strike percentage
  def called_strike_percentage(zone_id, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    @called_strike_percentages.where(zone_id: zone_id, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
  end

  # Retrieve contact percentage
  def contact_percentage(zone_id, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    @contact_percentages.where(zone_id: zone_id, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
  end

  # Retrieve pitch location (which zone the pitch will be in)
  # NOTE: random_between_0_and_1 is a variable that holds a random number between 0 and 1 (use rand() to generate)
  def pitch_location(random_between_0_and_1, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    zone_percentages = Array.new(72)
    count = 1
    sum = 0
    # Get the pitch location percentages for each zone
    72.times do
      zone_percentages[count] = @pitch_locations.where(zone_id: count, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
      sum += zone_percentages[count]
      count = count + 1
    end

    # Calculate which zone the pitch will be in, based on the percentages
    random_val = random_between_0_and_1 * sum
    count = 1
    sum = 0
    while random_val > sum do
      sum += zone_percentages[count]
      count = count + 1
    end
    count - 1 # Return the correct zone
  end

  # Retrieve swing percentage
  def swing_percentage(zone_id, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    @swing_percentages.where(zone_id: zone_id, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
  end

end
