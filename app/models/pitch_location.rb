class PitchLocation < ActiveRecord::Base

  def value
    pitch_percentage
  end
end
