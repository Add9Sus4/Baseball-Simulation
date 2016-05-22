# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

numUsers = 50 # How many users to add to database
numTeams = 10 # How many teams to add to database
numPlayersPerTeam = 13 # How many players on each team to add to database
teams = []

# Create initial user
# User.create!(name: "Example User",
#               email: "example@railstutorial.org",
#               password: "foobar",
#               password_confirmation: "foobar",
#               admin: true,
#               activated: true,
#               activated_at: Time.zone.now)

# Create additional users
# (numUsers-1).times do |n|
#   name = Faker::Name.name
#   email = "example-#{n+1}@railstutorial.org"
#   password = "password"
#   User.create!(name: name,
#                 email: email,
#                 password: password,
#                 password_confirmation: password,
#                 activated: true,
#                 activated_at: Time.zone.now)
# end

# Create teams
numTeams.times do
  city = Faker::Address.city
  name = Faker::Team.creature.capitalize
  league = ["NL","AL"].sample
  division = ["East","Central","West"].sample
  stadium = name + " " + ["Stadium","Field","Park","Coliseum","Center"].sample
  capacity = 45000
  newTeam = Team.create!(city: city,
  name: name,
  league: league,
  division: division,
  stadium: stadium,
  capacity: capacity)
  teams.unshift(newTeam)
end

# Create players for each team
teams.each do |team|
  players = []
  numPlayersPerTeam.times do
    newPlayer = Player.create!(team_id: team.id,
                                first_name: Faker::Name.first_name,
                                last_name: Faker::Name.last_name,
                                age: rand(17..40),
                                height: rand(66..78),
                                weight: rand(160..300),
                                position: ['P','C','1B','2B','3B','SS','LF','CF','RF'].sample,
                                salary: rand(500000..20000000),
                                power: rand(1..100),
                                contact: rand(1..100),
                                speed: rand(1..100),
                                patience: rand(1..100),
                                plate_vision: rand(1..100),
                                pull_amount: rand(1..100),
                                uppercut_amount: rand(1..100),
                                batting_average: rand(1..100),
                                movement: rand(1..100),
                                control: rand(1..100),
                                location: rand(1..100),
                                agility: rand(1..100),
                                reactionTime: rand(1..100),
                                armStrength: rand(1..100),
                                fieldGrounder: rand(1..100),
                                fieldLiner: rand(1..100),
                                fieldFlyball: rand(1..100),
                                fieldPopup: rand(1..100),
                                throwShort: rand(1..100),
                                throwMedium: rand(1..100),
                                throwLong: rand(1..100),
                                intelligence: rand(1..100),
                                endurance: rand(1..100))
    players.unshift(newPlayer)
  end
  city = Faker::Address.city
  name = Faker::Team.creature.capitalize
  league = ["NL","AL"].sample
  division = ["East","Central","West"].sample
  stadium = name + " " + ["Stadium","Field","Park","Coliseum","Center"].sample
  capacity = 45000
  team.update(
  catcher: players[0].id,
  designated_hitter: players[1].id,
  first_base: players[2].id,
  second_base: players[3].id,
  third_base: players[4].id,
  shortstop: players[5].id,
  left_field: players[6].id,
  center_field: players[7].id,
  right_field: players[8].id,
  lineup1: 0,
  lineup2: 1,
  lineup3: 2,
  lineup4: 3,
  lineup5: 4,
  lineup6: 5,
  lineup7: 6,
  lineup8: 7,
  lineup9: 8)
end
