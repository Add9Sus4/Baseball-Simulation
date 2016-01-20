json.array!(@players) do |player|
  json.extract! player, :id, :team_id, :first_name, :last_name, :age, :height, :weight, :position, :salary, :power, :contact, :speed, :patience, :plate_vision, :pull_amount, :uppercut_amount, :batting_average, :movement, :control, :location, :agility, :reactionTime, :armStrength, :fieldGrounder, :fieldLiner, :fieldFlyball, :fieldPopup, :throwShort, :throwMedium, :throwLong, :intelligence, :endurance
  json.url player_url(player, format: :json)
end
