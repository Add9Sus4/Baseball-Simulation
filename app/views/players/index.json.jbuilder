json.array!(@players) do |player|
  json.extract! player, :id, :team_id, :first_name, :last_name, :age, :height, :weight, :position, :salary
  json.url player_url(player, format: :json)
end
