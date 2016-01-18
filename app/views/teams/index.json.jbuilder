json.array!(@teams) do |team|
  json.extract! team, :id, :city, :name, :league, :division, :stadium, :capacity
  json.url team_url(team, format: :json)
end
