# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

numUsers = 2 # How many users to add to database
numTeams = 5 # How many teams per division to add to database
numPlayersPerTeam = 13 # How many players on each team to add to database
numPitchersPerTeam = 12 # How many pitchers on each team to add to database
teams = []

# Create initial user
User.create!(name: "Example User",
              email: "example@railstutorial.org",
              password: "foobar",
              password_confirmation: "foobar",
              admin: true,
              activated: true,
              activated_at: Time.zone.now,
              team_id: -1)

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

def completely_random_player(team_id)

  Player.create!(team_id: team_id,
                              first_name: Faker::Name.first_name,
                              last_name: Faker::Name.last_name,
                              age: rand(17..40),
                              height: rand(66..78),
                              weight: rand(160..300),
                              position: ['C','1B','2B','3B','SS','LF','CF','RF'].sample,
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
                              endurance: rand(1..100),
                              atbats: 0,
                              runs: 0,
                              hits: 0,
                              doubles: 0,
                              triples: 0,
                              home_runs: 0,
                              rbi: 0,
                              walks: 0,
                              strikeouts: 0,
                              stolen_bases: 0,
                              caught_stealing: 0,
                              errors_committed: 0,
                              assists: 0,
                              putouts: 0,
                              chances: 0,
                              outs_recorded: 0,
                              hits_allowed: 0,
                              runs_allowed: 0,
                              earned_runs_allowed: 0,
                              walks_allowed: 0,
                              strikeouts_recorded: 0,
                              home_runs_allowed: 0,
                              total_pitches: 0,
                              strikes_thrown: 0,
                              balls_thrown: 0,
                              intentional_walks_allowed: 0,
                              zone_1_pitches: 0,
                              zone_2_pitches: 0,
                              zone_3_pitches: 0,
                              zone_4_pitches: 0,
                              zone_5_pitches: 0,
                              zone_6_pitches: 0,
                              zone_7_pitches: 0,
                              zone_8_pitches: 0,
                              zone_9_pitches: 0,
                              zone_10_pitches: 0,
                              zone_11_pitches: 0,
                              zone_12_pitches: 0,
                              zone_13_pitches: 0,
                              zone_14_pitches: 0,
                              zone_15_pitches: 0,
                              zone_16_pitches: 0,
                              zone_17_pitches: 0,
                              zone_18_pitches: 0,
                              zone_19_pitches: 0,
                              zone_20_pitches: 0,
                              zone_21_pitches: 0,
                              zone_22_pitches: 0,
                              zone_23_pitches: 0,
                              zone_24_pitches: 0,
                              zone_25_pitches: 0,
                              zone_26_pitches: 0,
                              zone_27_pitches: 0,
                              zone_28_pitches: 0,
                              zone_29_pitches: 0,
                              zone_30_pitches: 0,
                              zone_31_pitches: 0,
                              zone_32_pitches: 0,
                              zone_33_pitches: 0,
                              zone_34_pitches: 0,
                              zone_35_pitches: 0,
                              zone_36_pitches: 0,
                              zone_37_pitches: 0,
                              zone_38_pitches: 0,
                              zone_39_pitches: 0,
                              zone_40_pitches: 0,
                              zone_41_pitches: 0,
                              zone_42_pitches: 0,
                              zone_43_pitches: 0,
                              zone_44_pitches: 0,
                              zone_45_pitches: 0,
                              zone_46_pitches: 0,
                              zone_47_pitches: 0,
                              zone_48_pitches: 0,
                              zone_49_pitches: 0,
                              zone_50_pitches: 0,
                              zone_51_pitches: 0,
                              zone_52_pitches: 0,
                              zone_53_pitches: 0,
                              zone_54_pitches: 0,
                              zone_55_pitches: 0,
                              zone_56_pitches: 0,
                              zone_57_pitches: 0,
                              zone_58_pitches: 0,
                              zone_59_pitches: 0,
                              zone_60_pitches: 0,
                              zone_61_pitches: 0,
                              zone_62_pitches: 0,
                              zone_63_pitches: 0,
                              zone_64_pitches: 0,
                              zone_65_pitches: 0,
                              zone_66_pitches: 0,
                              zone_67_pitches: 0,
                              zone_68_pitches: 0,
                              zone_69_pitches: 0,
                              zone_70_pitches: 0,
                              zone_71_pitches: 0,
                              zone_72_pitches: 0,
                              throwing_hand: ["LEFT","RIGHT"].sample,
                              hitting_side: ["LEFT","RIGHT"].sample,
                              pitch_1: "--",
                              pitch_2: "--",
                              pitch_3: "--",
                              pitch_4: "--",
                              pitch_5: "--",
                              wins: 0,
                              losses: 0)



end

def completely_average_player(team_id)

  Player.create!(team_id: team_id,
                              first_name: Faker::Name.first_name,
                              last_name: Faker::Name.last_name,
                              age: rand(17..40),
                              height: rand(66..78),
                              weight: rand(160..300),
                              position: ['C','1B','2B','3B','SS','LF','CF','RF'].sample,
                              salary: rand(500000..20000000),
                              power: 50,
                              contact: 50,
                              speed: 50,
                              patience: 50,
                              plate_vision: 50,
                              pull_amount: 50,
                              uppercut_amount: 50,
                              batting_average: 50,
                              movement: 50,
                              control: 50,
                              location: 50,
                              agility: 50,
                              reactionTime: 50,
                              armStrength: 50,
                              fieldGrounder: 50,
                              fieldLiner: 50,
                              fieldFlyball: 50,
                              fieldPopup: 50,
                              throwShort: 50,
                              throwMedium: 50,
                              throwLong: 50,
                              intelligence: 50,
                              endurance: 50,
                              atbats: 0,
                              runs: 0,
                              hits: 0,
                              doubles: 0,
                              triples: 0,
                              home_runs: 0,
                              rbi: 0,
                              walks: 0,
                              strikeouts: 0,
                              stolen_bases: 0,
                              caught_stealing: 0,
                              errors_committed: 0,
                              assists: 0,
                              putouts: 0,
                              chances: 0,
                              outs_recorded: 0,
                              hits_allowed: 0,
                              runs_allowed: 0,
                              earned_runs_allowed: 0,
                              walks_allowed: 0,
                              strikeouts_recorded: 0,
                              home_runs_allowed: 0,
                              total_pitches: 0,
                              strikes_thrown: 0,
                              balls_thrown: 0,
                              intentional_walks_allowed: 0,
                              zone_1_pitches: 0,
                              zone_2_pitches: 0,
                              zone_3_pitches: 0,
                              zone_4_pitches: 0,
                              zone_5_pitches: 0,
                              zone_6_pitches: 0,
                              zone_7_pitches: 0,
                              zone_8_pitches: 0,
                              zone_9_pitches: 0,
                              zone_10_pitches: 0,
                              zone_11_pitches: 0,
                              zone_12_pitches: 0,
                              zone_13_pitches: 0,
                              zone_14_pitches: 0,
                              zone_15_pitches: 0,
                              zone_16_pitches: 0,
                              zone_17_pitches: 0,
                              zone_18_pitches: 0,
                              zone_19_pitches: 0,
                              zone_20_pitches: 0,
                              zone_21_pitches: 0,
                              zone_22_pitches: 0,
                              zone_23_pitches: 0,
                              zone_24_pitches: 0,
                              zone_25_pitches: 0,
                              zone_26_pitches: 0,
                              zone_27_pitches: 0,
                              zone_28_pitches: 0,
                              zone_29_pitches: 0,
                              zone_30_pitches: 0,
                              zone_31_pitches: 0,
                              zone_32_pitches: 0,
                              zone_33_pitches: 0,
                              zone_34_pitches: 0,
                              zone_35_pitches: 0,
                              zone_36_pitches: 0,
                              zone_37_pitches: 0,
                              zone_38_pitches: 0,
                              zone_39_pitches: 0,
                              zone_40_pitches: 0,
                              zone_41_pitches: 0,
                              zone_42_pitches: 0,
                              zone_43_pitches: 0,
                              zone_44_pitches: 0,
                              zone_45_pitches: 0,
                              zone_46_pitches: 0,
                              zone_47_pitches: 0,
                              zone_48_pitches: 0,
                              zone_49_pitches: 0,
                              zone_50_pitches: 0,
                              zone_51_pitches: 0,
                              zone_52_pitches: 0,
                              zone_53_pitches: 0,
                              zone_54_pitches: 0,
                              zone_55_pitches: 0,
                              zone_56_pitches: 0,
                              zone_57_pitches: 0,
                              zone_58_pitches: 0,
                              zone_59_pitches: 0,
                              zone_60_pitches: 0,
                              zone_61_pitches: 0,
                              zone_62_pitches: 0,
                              zone_63_pitches: 0,
                              zone_64_pitches: 0,
                              zone_65_pitches: 0,
                              zone_66_pitches: 0,
                              zone_67_pitches: 0,
                              zone_68_pitches: 0,
                              zone_69_pitches: 0,
                              zone_70_pitches: 0,
                              zone_71_pitches: 0,
                              zone_72_pitches: 0,
                              throwing_hand: ["LEFT","RIGHT"].sample,
                              hitting_side: ["LEFT","RIGHT"].sample,
                              pitch_1: "--",
                              pitch_2: "--",
                              pitch_3: "--",
                              pitch_4: "--",
                              pitch_5: "--",
                              wins: 0,
                              losses: 0)
end

def completely_random_pitcher(team_id)

  # Create the pitch types
  pitch_types_1 = ['FA']
  pitch_types_2 = ['FT','SL','CU','CH']
  pitch_types_3 = ['SI','FC','FS']
  pitch_types_4 = ['FO','KN','SC','KC']
  pitch_types_5 = ['EP','UN']

  pitches = Array.new

  total_pitches = rand(2..5)

  while pitches.length < total_pitches do
    if pitch_types_1.length > 0 then pitches.push(pitch_types_1.delete_at(rand(pitch_types_1.length))) end
    rand(1..4).times do
      if pitch_types_2.length > 0 then pitches.push(pitch_types_2.delete_at(rand(pitch_types_2.length))) end
      if pitches.length >= total_pitches then break end
    end
    rand(0..1).times do
      if pitch_types_3.length > 0 then pitches.push(pitch_types_3.delete_at(rand(pitch_types_3.length))) end
    end
    rand(0..1).times do
      if pitch_types_4.length > 0 then pitches.push(pitch_types_4.delete_at(rand(pitch_types_4.length))) end
    end
    rand(0..1).times do
      if pitch_types_5.length > 0 then pitches.push(pitch_types_5.delete_at(rand(pitch_types_5.length))) end
    end
  end

  extra_pitches = 5 - total_pitches
  extra_pitches.times do
    pitches.push('--')
  end

  Player.create!(team_id: team_id,
                              first_name: Faker::Name.first_name,
                              last_name: Faker::Name.last_name,
                              age: rand(17..40),
                              height: rand(66..78),
                              weight: rand(160..300),
                              position: 'P',
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
                              endurance: rand(1..100),
                              atbats: 0,
                              runs: 0,
                              hits: 0,
                              doubles: 0,
                              triples: 0,
                              home_runs: 0,
                              rbi: 0,
                              walks: 0,
                              strikeouts: 0,
                              stolen_bases: 0,
                              caught_stealing: 0,
                              errors_committed: 0,
                              assists: 0,
                              putouts: 0,
                              chances: 0,
                              outs_recorded: 0,
                              hits_allowed: 0,
                              runs_allowed: 0,
                              earned_runs_allowed: 0,
                              walks_allowed: 0,
                              strikeouts_recorded: 0,
                              home_runs_allowed: 0,
                              total_pitches: 0,
                              strikes_thrown: 0,
                              balls_thrown: 0,
                              intentional_walks_allowed: 0,
                              zone_1_pitches: 0,
                              zone_2_pitches: 0,
                              zone_3_pitches: 0,
                              zone_4_pitches: 0,
                              zone_5_pitches: 0,
                              zone_6_pitches: 0,
                              zone_7_pitches: 0,
                              zone_8_pitches: 0,
                              zone_9_pitches: 0,
                              zone_10_pitches: 0,
                              zone_11_pitches: 0,
                              zone_12_pitches: 0,
                              zone_13_pitches: 0,
                              zone_14_pitches: 0,
                              zone_15_pitches: 0,
                              zone_16_pitches: 0,
                              zone_17_pitches: 0,
                              zone_18_pitches: 0,
                              zone_19_pitches: 0,
                              zone_20_pitches: 0,
                              zone_21_pitches: 0,
                              zone_22_pitches: 0,
                              zone_23_pitches: 0,
                              zone_24_pitches: 0,
                              zone_25_pitches: 0,
                              zone_26_pitches: 0,
                              zone_27_pitches: 0,
                              zone_28_pitches: 0,
                              zone_29_pitches: 0,
                              zone_30_pitches: 0,
                              zone_31_pitches: 0,
                              zone_32_pitches: 0,
                              zone_33_pitches: 0,
                              zone_34_pitches: 0,
                              zone_35_pitches: 0,
                              zone_36_pitches: 0,
                              zone_37_pitches: 0,
                              zone_38_pitches: 0,
                              zone_39_pitches: 0,
                              zone_40_pitches: 0,
                              zone_41_pitches: 0,
                              zone_42_pitches: 0,
                              zone_43_pitches: 0,
                              zone_44_pitches: 0,
                              zone_45_pitches: 0,
                              zone_46_pitches: 0,
                              zone_47_pitches: 0,
                              zone_48_pitches: 0,
                              zone_49_pitches: 0,
                              zone_50_pitches: 0,
                              zone_51_pitches: 0,
                              zone_52_pitches: 0,
                              zone_53_pitches: 0,
                              zone_54_pitches: 0,
                              zone_55_pitches: 0,
                              zone_56_pitches: 0,
                              zone_57_pitches: 0,
                              zone_58_pitches: 0,
                              zone_59_pitches: 0,
                              zone_60_pitches: 0,
                              zone_61_pitches: 0,
                              zone_62_pitches: 0,
                              zone_63_pitches: 0,
                              zone_64_pitches: 0,
                              zone_65_pitches: 0,
                              zone_66_pitches: 0,
                              zone_67_pitches: 0,
                              zone_68_pitches: 0,
                              zone_69_pitches: 0,
                              zone_70_pitches: 0,
                              zone_71_pitches: 0,
                              zone_72_pitches: 0,
                              throwing_hand: ["LEFT","RIGHT"].sample,
                              hitting_side: ["LEFT","RIGHT"].sample,
                              pitch_1: pitches[0],
                              pitch_2: pitches[1],
                              pitch_3: pitches[2],
                              pitch_4: pitches[3],
                              pitch_5: pitches[4],
                              wins: 0,
                              losses: 0 )



end

def completely_average_pitcher(team_id)

  # Create the pitch types
  pitch_types_1 = ['FA']
  pitch_types_2 = ['FT','SL','CU','CH']
  pitch_types_3 = ['SI','FC','FS']
  pitch_types_4 = ['FO','KN','SC','KC']
  pitch_types_5 = ['EP','UN']

  pitches = Array.new

  total_pitches = rand(2..5)

  while pitches.length <= total_pitches do
    pitches.push(pitch_types_1.sample.pop)
    rand(1..4).times do
      pitches.push(pitch_types_2.sample.pop)
    end
    rand(0..1).times do
      pitches.push(pitch_types_3.sample.pop)
    end
    rand(0..1).times do
      pitches.push(pitch_types_4.sample.pop)
    end
    rand(0..1).times do
      pitches.push(pitch_types_5.sample.pop)
    end
  end

  extra_pitches = 5 - total_pitches
  extra_pitches.times do
    pitches.push('--')
  end

  Player.create!(team_id: team_id,
                              first_name: Faker::Name.first_name,
                              last_name: Faker::Name.last_name,
                              age: rand(17..40),
                              height: rand(66..78),
                              weight: rand(160..300),
                              position: 'P',
                              salary: rand(500000..20000000),
                              power: 50,
                              contact: 50,
                              speed: 50,
                              patience: 50,
                              plate_vision: 50,
                              pull_amount: 50,
                              uppercut_amount: 50,
                              batting_average: 50,
                              movement: 50,
                              control: 50,
                              location: 50,
                              agility: 50,
                              reactionTime: 50,
                              armStrength: 50,
                              fieldGrounder: 50,
                              fieldLiner: 50,
                              fieldFlyball: 50,
                              fieldPopup: 50,
                              throwShort: 50,
                              throwMedium: 50,
                              throwLong: 50,
                              intelligence: 50,
                              endurance: 50,
                              atbats: 0,
                              runs: 0,
                              hits: 0,
                              doubles: 0,
                              triples: 0,
                              home_runs: 0,
                              rbi: 0,
                              walks: 0,
                              strikeouts: 0,
                              stolen_bases: 0,
                              caught_stealing: 0,
                              errors_committed: 0,
                              assists: 0,
                              putouts: 0,
                              chances: 0,
                              outs_recorded: 0,
                              hits_allowed: 0,
                              runs_allowed: 0,
                              earned_runs_allowed: 0,
                              walks_allowed: 0,
                              strikeouts_recorded: 0,
                              home_runs_allowed: 0,
                              total_pitches: 0,
                              strikes_thrown: 0,
                              balls_thrown: 0,
                              intentional_walks_allowed: 0,
                              zone_1_pitches: 0,
                              zone_2_pitches: 0,
                              zone_3_pitches: 0,
                              zone_4_pitches: 0,
                              zone_5_pitches: 0,
                              zone_6_pitches: 0,
                              zone_7_pitches: 0,
                              zone_8_pitches: 0,
                              zone_9_pitches: 0,
                              zone_10_pitches: 0,
                              zone_11_pitches: 0,
                              zone_12_pitches: 0,
                              zone_13_pitches: 0,
                              zone_14_pitches: 0,
                              zone_15_pitches: 0,
                              zone_16_pitches: 0,
                              zone_17_pitches: 0,
                              zone_18_pitches: 0,
                              zone_19_pitches: 0,
                              zone_20_pitches: 0,
                              zone_21_pitches: 0,
                              zone_22_pitches: 0,
                              zone_23_pitches: 0,
                              zone_24_pitches: 0,
                              zone_25_pitches: 0,
                              zone_26_pitches: 0,
                              zone_27_pitches: 0,
                              zone_28_pitches: 0,
                              zone_29_pitches: 0,
                              zone_30_pitches: 0,
                              zone_31_pitches: 0,
                              zone_32_pitches: 0,
                              zone_33_pitches: 0,
                              zone_34_pitches: 0,
                              zone_35_pitches: 0,
                              zone_36_pitches: 0,
                              zone_37_pitches: 0,
                              zone_38_pitches: 0,
                              zone_39_pitches: 0,
                              zone_40_pitches: 0,
                              zone_41_pitches: 0,
                              zone_42_pitches: 0,
                              zone_43_pitches: 0,
                              zone_44_pitches: 0,
                              zone_45_pitches: 0,
                              zone_46_pitches: 0,
                              zone_47_pitches: 0,
                              zone_48_pitches: 0,
                              zone_49_pitches: 0,
                              zone_50_pitches: 0,
                              zone_51_pitches: 0,
                              zone_52_pitches: 0,
                              zone_53_pitches: 0,
                              zone_54_pitches: 0,
                              zone_55_pitches: 0,
                              zone_56_pitches: 0,
                              zone_57_pitches: 0,
                              zone_58_pitches: 0,
                              zone_59_pitches: 0,
                              zone_60_pitches: 0,
                              zone_61_pitches: 0,
                              zone_62_pitches: 0,
                              zone_63_pitches: 0,
                              zone_64_pitches: 0,
                              zone_65_pitches: 0,
                              zone_66_pitches: 0,
                              zone_67_pitches: 0,
                              zone_68_pitches: 0,
                              zone_69_pitches: 0,
                              zone_70_pitches: 0,
                              zone_71_pitches: 0,
                              zone_72_pitches: 0,
                              throwing_hand: ["LEFT","RIGHT"].sample,
                              hitting_side: ["LEFT","RIGHT"].sample,
                              pitch_1: pitches[0],
                              pitch_2: pitches[1],
                              pitch_3: pitches[2],
                              pitch_4: pitches[3],
                              pitch_5: pitches[4],
                              wins: 0,
                              losses: 0)
end

# Create season
season = Season.create!(next_game: 0, simulating: 1)

["NL", "AL"].each do |current_league|
  ["East", "Central", "West"].each do |current_division|
    # Create teams
    numTeams.times do
      city = Faker::Address.city
      name = Faker::Team.creature.capitalize
      league = current_league
      division = current_division
      stadium = name + " " + ["Stadium","Field","Park","Coliseum","Center"].sample
      capacity = 45000
      newTeam = Team.create!(city: city,
      name: name,
      league: league,
      division: division,
      stadium: stadium,
      capacity: capacity,
      streak: 0,
      rotation_position: 1,
      user_id: -1)
      teams.unshift(newTeam)
    end

    # Create players for each team
    teams.each do |team|
      players = []
      numPlayersPerTeam.times do
        newPlayer = completely_random_player(team.id)
        players.unshift(newPlayer)
      end
      team.update(
      catcher: players[12].id,
      designated_hitter: players[11].id,
      first_base: players[10].id,
      second_base: players[9].id,
      third_base: players[8].id,
      shortstop: players[7].id,
      left_field: players[6].id,
      center_field: players[5].id,
      right_field: players[4].id,
      lineup1: 0,
      lineup2: 1,
      lineup3: 2,
      lineup4: 3,
      lineup5: 4,
      lineup6: 5,
      lineup7: 6,
      lineup8: 7,
      lineup9: 8,
      wins: 0,
      losses: 0,
      runs_scored: 0,
      runs_allowed: 0,
      schedule: "")
    end
    # Create pitchers for each team
    teams.each do |team|
      pitchers = []
      numPitchersPerTeam.times do
        newPitcher = completely_random_pitcher(team.id)
        pitchers.unshift(newPitcher)
      end
      team.update(
      sp1: pitchers[0].id,
      sp2: pitchers[1].id,
      sp3: pitchers[2].id,
      sp4: pitchers[3].id,
      sp5: pitchers[4].id,
      lr: pitchers[5].id,
      mr1: pitchers[6].id,
      mr2: pitchers[7].id,
      mr3: pitchers[8].id,
      su1: pitchers[9].id,
      su2: pitchers[10].id,
      cl: pitchers[11].id)
    end

    teams.clear

  end
end

# Reload the teams
@all_teams = Team.all

# Create the schedules

# First, determine series lengths
TOTAL_TWO_GAME_SERIES = 2
TOTAL_THREE_GAME_SERIES = 38
TOTAL_FOUR_GAME_SERIES = 11

@two_game_series = 0
@three_game_series = 0
@four_game_series = 0

def two_game_series_remaining
    TOTAL_TWO_GAME_SERIES - @two_game_series
end

def three_game_series_remaining
    TOTAL_THREE_GAME_SERIES - @three_game_series
end

def four_game_series_remaining
    TOTAL_FOUR_GAME_SERIES - @four_game_series
end

@series_lengths = []

def add_series
    # determine length of new series
    rand = Random.new.rand(two_game_series_remaining + three_game_series_remaining + four_game_series_remaining)
    if rand < two_game_series_remaining
        @series_lengths.push(2)
        @two_game_series += 1
    elsif rand < two_game_series_remaining + three_game_series_remaining
        @series_lengths.push(3)
        @three_game_series += 1
    else
        @series_lengths.push(4)
        @four_game_series += 1
    end
end



51.times do
    add_series
end

# @counts = Hash.new 0

# @series_lengths.each do |series|
#     @counts[series] += 1
# end

# puts @series_lengths

# puts @counts

# Next, determine matchups
@all_teams = Team.all
@teams = []

@all_teams.each do |team|
  @teams.push(team.id)
end

@season_matchups = Hash.new 0

51.times do |index|

    @matchups = Hash.new 0
    @current_series_teams = Array.new(@teams)

    15.times do
        home_team = @current_series_teams.delete(@current_series_teams.sample)
        away_team = @current_series_teams.delete(@current_series_teams.sample)
        @matchups[home_team] = away_team
        @matchups[away_team] = home_team
    end

    @season_matchups[index] = @matchups

end

# puts @season_matchups

@team_schedules = Hash.new 0

30.times do |index|
    schedule = []
    51.times do |j|
        @series_lengths[j].times do
            schedule.push(@season_matchups[j][@teams[index]])
        end
    end
    @team_schedules[@teams[index]] = schedule
end

# @team_schedules is a hash where the key is the team id (here, 0 to 29) and the value is an array of opponent team ids (0 to 29)
# puts @team_schedules

@all_teams.each do |team|
  team.update(
  schedule: @team_schedules[team.id].to_s.chop[1..-1])
end
