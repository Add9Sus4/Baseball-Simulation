# If we only use one pitch type (for example, assume pitch_type = 'FA') then
# all heatmap data can be loaded in roughly 1 minute. If we use all pitch types,
# it will take around 15 minutes to complete
class HeatMap
  attr_accessor :called_strike_percentages, :contact_percentages, :pitch_locations, :swing_percentages
  def initialize

    start = Time.now

    @called_strike_percentages = Hash.new
    @contact_percentages = Hash.new
    @pitch_locations = Hash.new
    @swing_percentages = Hash.new
    zone = (1..72).to_a
    pitcher_hand = ["LEFT", "RIGHT"]
    batter_hand = ["LEFT", "RIGHT"]
    balls = (0..3).to_a
    strikes = (0..2).to_a
    pitch_type = ["CH", "CU", "EP", "FA", "FC", "FO", "FS", "FT", "KC", "KN", "SC", "SI", "SL", "UN"]

    zone.each do |zone|
      puts "Starting zone #{zone}..."
      pitcher_hand.each do |pitcher_hand|
        batter_hand.each do |batter_hand|
          balls.each do |balls|
            strikes.each do |strikes|
              pitch_type = "FA"
              # pitch_type.each do |pitch_type|
                key = "#{zone}_#{pitcher_hand}_#{batter_hand}_#{balls}_#{strikes}_#{pitch_type}"
                called_strike_percentage = CalledStrikePercentage.where(zone_id: zone, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
                contact_percentage = ContactPercentage.where(zone_id: zone, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
                pitch_location = PitchLocation.where(zone_id: zone, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
                swing_percentage = SwingPercentage.where(zone_id: zone, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
                @called_strike_percentages[key] = called_strike_percentage
                @contact_percentages[key] = contact_percentage
                @pitch_locations[key] = pitch_location
                @swing_percentages[key] = swing_percentage
              # end
            end
          end
        end
      end
      puts "Zone #{zone} complete."
    end
    finish = Time.now
    puts "Total time: #{finish - start} s"
  end
end
