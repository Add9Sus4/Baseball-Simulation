# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'ffaker'

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

def generate_random_player_attributes
  attributes_hash = {
    "First Name" => FFaker::Name.first_name_male,
    "Last Name" => Faker::Name.last_name,
    "Age" => rand(17..40),
    "Height" => rand(66..78),
    "Weight" => rand(160..300),
    "Power" => rand(1..100),
    "Contact" => rand(1..100),
    "Speed" => rand(1..100),
    "Patience" => rand(1..100),
    "Plate Vision" => rand(1..100),
    "Pull Amount" => rand(1..100),
    "Uppercut Amount" => rand(1..100),
    "Batting Average" => rand(1..100),
    "Movement" => rand(1..100),
    "Control" => rand(1..100),
    "Location" => rand(1..100),
    "Agility" => rand(1..100),
    "Reaction Time" => rand(1..100),
    "Arm Strength" => rand(1..100),
    "Field Grounder" => rand(1..100),
    "Field Liner" => rand(1..100),
    "Field Flyball" => rand(1..100),
    "Field Popup" => rand(1..100),
    "Throw Short" => rand(1..100),
    "Throw Medium" => rand(1..100),
    "Throw Long" => rand(1..100),
    "Intelligence" => rand(1..100),
    "Endurance" => rand(1..100)
  }

  # Calculate salary based on other attributes
  salary = 0
  salary += attributes_hash["Power"]*10000
  salary += attributes_hash["Contact"]*5000
  salary += attributes_hash["Speed"]*8000
  salary += attributes_hash["Patience"]*5000
  salary += attributes_hash["Plate Vision"]*8000
  salary += attributes_hash["Uppercut Amount"]*2000
  salary += attributes_hash["Batting Average"]*10000
  salary += attributes_hash["Agility"]*3000
  salary += attributes_hash["Reaction Time"]*3000
  salary += attributes_hash["Field Grounder"]*1000
  salary += attributes_hash["Field Liner"]*1000
  salary += attributes_hash["Field Flyball"]*1000
  salary += attributes_hash["Field Popup"]*1000
  salary += attributes_hash["Throw Short"]*1000
  salary += attributes_hash["Throw Medium"]*1000
  salary += attributes_hash["Throw Long"]*1000
  salary += attributes_hash["Intelligence"]*2000
  salary += attributes_hash["Endurance"]*2000

  # Randomize salary a little bit
  salary *= rand(0.9..1.11)

  attributes_hash["Salary"] = salary
  attributes_hash
end
def generate_average_player_attributes
  attributes_hash = {
    "First Name" => FFaker::Name.first_name_male,
    "Last Name" => Faker::Name.last_name,
    "Age" => rand(17..40),
    "Height" => rand(66..78),
    "Weight" => rand(160..300),
    "Power" => 50,
    "Contact" => 50,
    "Speed" => 50,
    "Patience" => 50,
    "Plate Vision" => 50,
    "Pull Amount" => 50,
    "Uppercut Amount" => 50,
    "Batting Average" => 50,
    "Movement" => 50,
    "Control" => 50,
    "Location" => 50,
    "Agility" => 50,
    "Reaction Time" => 50,
    "Arm Strength" => 50,
    "Field Grounder" => 50,
    "Field Liner" => 50,
    "Field Flyball" => 50,
    "Field Popup" => 50,
    "Throw Short" => 50,
    "Throw Medium" => 50,
    "Throw Long" => 50,
    "Intelligence" => 50,
    "Endurance" => 50
  }

  # Calculate salary based on other attributes
  salary = 0
  salary += attributes_hash["Power"]*10000
  salary += attributes_hash["Contact"]*5000
  salary += attributes_hash["Speed"]*8000
  salary += attributes_hash["Patience"]*5000
  salary += attributes_hash["Plate Vision"]*8000
  salary += attributes_hash["Uppercut Amount"]*2000
  salary += attributes_hash["Batting Average"]*10000
  salary += attributes_hash["Agility"]*3000
  salary += attributes_hash["Reaction Time"]*3000
  salary += attributes_hash["Field Grounder"]*1000
  salary += attributes_hash["Field Liner"]*1000
  salary += attributes_hash["Field Flyball"]*1000
  salary += attributes_hash["Field Popup"]*1000
  salary += attributes_hash["Throw Short"]*1000
  salary += attributes_hash["Throw Medium"]*1000
  salary += attributes_hash["Throw Long"]*1000
  salary += attributes_hash["Intelligence"]*2000
  salary += attributes_hash["Endurance"]*2000

  # Randomize salary a little bit
  salary *= rand(0.9..1.11)

  attributes_hash["Salary"] = salary
  attributes_hash
end
def generate_random_pitcher_attributes
  attributes_hash = {
    "First Name" => FFaker::Name.first_name_male,
    "Last Name" => Faker::Name.last_name,
    "Age" => rand(17..40),
    "Height" => rand(66..78),
    "Weight" => rand(160..300),
    "Power" => rand(1..100),
    "Contact" => rand(1..100),
    "Speed" => rand(1..100),
    "Patience" => rand(1..100),
    "Plate Vision" => rand(1..100),
    "Pull Amount" => rand(1..100),
    "Uppercut Amount" => rand(1..100),
    "Batting Average" => rand(1..100),
    "Movement" => rand(1..100),
    "Control" => rand(1..100),
    "Location" => rand(1..100),
    "Agility" => rand(1..100),
    "Reaction Time" => rand(1..100),
    "Arm Strength" => rand(1..100),
    "Field Grounder" => rand(1..100),
    "Field Liner" => rand(1..100),
    "Field Flyball" => rand(1..100),
    "Field Popup" => rand(1..100),
    "Throw Short" => rand(1..100),
    "Throw Medium" => rand(1..100),
    "Throw Long" => rand(1..100),
    "Intelligence" => rand(1..100),
    "Endurance" => rand(1..100)
  }

  # Calculate salary based on other attributes
  salary = 0
  salary += attributes_hash["Movement"]*10000
  salary += attributes_hash["Control"]*10000
  salary += attributes_hash["Location"]*10000
  salary += attributes_hash["Agility"]*1000
  salary += attributes_hash["Reaction Time"]*1000
  salary += attributes_hash["Arm Strength"]*10000
  salary += attributes_hash["Field Grounder"]*1000
  salary += attributes_hash["Field Liner"]*1000
  salary += attributes_hash["Field Popup"]*1000
  salary += attributes_hash["Throw Short"]*1000
  salary += attributes_hash["Intelligence"]*5000
  salary += attributes_hash["Endurance"]*8000

  # Randomize salary a little bit
  salary *= rand(0.9..1.11)

  attributes_hash["Salary"] = salary
  attributes_hash
end
def generate_average_pitcher_attributes
  attributes_hash = {
    "First Name" => FFaker::Name.first_name_male,
    "Last Name" => Faker::Name.last_name,
    "Age" => rand(17..40),
    "Height" => rand(66..78),
    "Weight" => rand(160..300),
    "Power" => 50,
    "Contact" => 50,
    "Speed" => 50,
    "Patience" => 50,
    "Plate Vision" => 50,
    "Pull Amount" => 50,
    "Uppercut Amount" => 50,
    "Batting Average" => 50,
    "Movement" => 50,
    "Control" => 50,
    "Location" => 50,
    "Agility" => 50,
    "Reaction Time" => 50,
    "Arm Strength" => 50,
    "Field Grounder" => 50,
    "Field Liner" => 50,
    "Field Flyball" => 50,
    "Field Popup" => 50,
    "Throw Short" => 50,
    "Throw Medium" => 50,
    "Throw Long" => 50,
    "Intelligence" => 50,
    "Endurance" => 50
  }

  # Calculate salary based on other attributes
  salary = 0
  salary += attributes_hash["Movement"]*10000
  salary += attributes_hash["Control"]*10000
  salary += attributes_hash["Location"]*10000
  salary += attributes_hash["Agility"]*1000
  salary += attributes_hash["Reaction Time"]*1000
  salary += attributes_hash["Arm Strength"]*10000
  salary += attributes_hash["Field Grounder"]*1000
  salary += attributes_hash["Field Liner"]*1000
  salary += attributes_hash["Field Popup"]*1000
  salary += attributes_hash["Throw Short"]*1000
  salary += attributes_hash["Intelligence"]*5000
  salary += attributes_hash["Endurance"]*8000

  # Randomize salary a little bit
  salary *= rand(0.9..1.11)

  attributes_hash["Salary"] = salary
  attributes_hash
end

def completely_random_player(team_id)

  attributes_hash = generate_random_player_attributes

  Player.create!(team_id: team_id,
                              first_name: attributes_hash["First Name"],
                              last_name: attributes_hash["Last Name"],
                              age: attributes_hash["Age"],
                              height: attributes_hash["Height"],
                              weight: attributes_hash["Weight"],
                              position: ['C','1B','2B','3B','SS','LF','CF','RF'].sample,
                              salary: attributes_hash["Salary"],
                              power: attributes_hash["Power"],
                              contact: attributes_hash["Contact"],
                              speed: attributes_hash["Speed"],
                              patience: attributes_hash["Patience"],
                              plate_vision: attributes_hash["Plate Vision"],
                              pull_amount: attributes_hash["Pull Amount"],
                              uppercut_amount: attributes_hash["Uppercut Amount"],
                              batting_average: attributes_hash["Batting Average"],
                              movement: attributes_hash["Movement"],
                              control: attributes_hash["Control"],
                              location: attributes_hash["Location"],
                              agility: attributes_hash["Agility"],
                              reactionTime: attributes_hash["Reaction Time"],
                              armStrength: attributes_hash["Arm Strength"],
                              fieldGrounder: attributes_hash["Field Grounder"],
                              fieldLiner: attributes_hash["Field Liner"],
                              fieldFlyball: attributes_hash["Field Flyball"],
                              fieldPopup: attributes_hash["Field Popup"],
                              throwShort: attributes_hash["Throw Short"],
                              throwMedium: attributes_hash["Throw Medium"],
                              throwLong: attributes_hash["Throw Long"],
                              intelligence: attributes_hash["Intelligence"],
                              endurance: attributes_hash["Endurance"],
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

  attributes_hash = generate_average_player_attributes

  Player.create!(team_id: team_id,
                              first_name: attributes_hash["First Name"],
                              last_name: attributes_hash["Last Name"],
                              age: attributes_hash["Age"],
                              height: attributes_hash["Height"],
                              weight: attributes_hash["Weight"],
                              position: ['C','1B','2B','3B','SS','LF','CF','RF'].sample,
                              salary: attributes_hash["Salary"],
                              power: attributes_hash["Power"],
                              contact: attributes_hash["Contact"],
                              speed: attributes_hash["Speed"],
                              patience: attributes_hash["Patience"],
                              plate_vision: attributes_hash["Plate Vision"],
                              pull_amount: attributes_hash["Pull Amount"],
                              uppercut_amount: attributes_hash["Uppercut Amount"],
                              batting_average: attributes_hash["Batting Average"],
                              movement: attributes_hash["Movement"],
                              control: attributes_hash["Control"],
                              location: attributes_hash["Location"],
                              agility: attributes_hash["Agility"],
                              reactionTime: attributes_hash["Reaction Time"],
                              armStrength: attributes_hash["Arm Strength"],
                              fieldGrounder: attributes_hash["Field Grounder"],
                              fieldLiner: attributes_hash["Field Liner"],
                              fieldFlyball: attributes_hash["Field Flyball"],
                              fieldPopup: attributes_hash["Field Popup"],
                              throwShort: attributes_hash["Throw Short"],
                              throwMedium: attributes_hash["Throw Medium"],
                              throwLong: attributes_hash["Throw Long"],
                              intelligence: attributes_hash["Intelligence"],
                              endurance: attributes_hash["Endurance"],
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

  attributes_hash = generate_random_pitcher_attributes

  Player.create!(team_id: team_id,
                              first_name: attributes_hash["First Name"],
                              last_name: attributes_hash["Last Name"],
                              age: attributes_hash["Age"],
                              height: attributes_hash["Height"],
                              weight: attributes_hash["Weight"],
                              position: 'P',
                              salary: attributes_hash["Salary"],
                              power: attributes_hash["Power"],
                              contact: attributes_hash["Contact"],
                              speed: attributes_hash["Speed"],
                              patience: attributes_hash["Patience"],
                              plate_vision: attributes_hash["Plate Vision"],
                              pull_amount: attributes_hash["Pull Amount"],
                              uppercut_amount: attributes_hash["Uppercut Amount"],
                              batting_average: attributes_hash["Batting Average"],
                              movement: attributes_hash["Movement"],
                              control: attributes_hash["Control"],
                              location: attributes_hash["Location"],
                              agility: attributes_hash["Agility"],
                              reactionTime: attributes_hash["Reaction Time"],
                              armStrength: attributes_hash["Arm Strength"],
                              fieldGrounder: attributes_hash["Field Grounder"],
                              fieldLiner: attributes_hash["Field Liner"],
                              fieldFlyball: attributes_hash["Field Flyball"],
                              fieldPopup: attributes_hash["Field Popup"],
                              throwShort: attributes_hash["Throw Short"],
                              throwMedium: attributes_hash["Throw Medium"],
                              throwLong: attributes_hash["Throw Long"],
                              intelligence: attributes_hash["Intelligence"],
                              endurance: attributes_hash["Endurance"],
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

  attributes_hash = generate_average_pitcher_attributes

  Player.create!(team_id: team_id,
                              first_name: attributes_hash["First Name"],
                              last_name: attributes_hash["Last Name"],
                              age: attributes_hash["Age"],
                              height: attributes_hash["Height"],
                              weight: attributes_hash["Weight"],
                              position: 'P',
                              salary: attributes_hash["Salary"],
                              power: attributes_hash["Power"],
                              contact: attributes_hash["Contact"],
                              speed: attributes_hash["Speed"],
                              patience: attributes_hash["Patience"],
                              plate_vision: attributes_hash["Plate Vision"],
                              pull_amount: attributes_hash["Pull Amount"],
                              uppercut_amount: attributes_hash["Uppercut Amount"],
                              batting_average: attributes_hash["Batting Average"],
                              movement: attributes_hash["Movement"],
                              control: attributes_hash["Control"],
                              location: attributes_hash["Location"],
                              agility: attributes_hash["Agility"],
                              reactionTime: attributes_hash["Reaction Time"],
                              armStrength: attributes_hash["Arm Strength"],
                              fieldGrounder: attributes_hash["Field Grounder"],
                              fieldLiner: attributes_hash["Field Liner"],
                              fieldFlyball: attributes_hash["Field Flyball"],
                              fieldPopup: attributes_hash["Field Popup"],
                              throwShort: attributes_hash["Throw Short"],
                              throwMedium: attributes_hash["Throw Medium"],
                              throwLong: attributes_hash["Throw Long"],
                              intelligence: attributes_hash["Intelligence"],
                              endurance: attributes_hash["Endurance"],
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
      lineup1: players[12].id,
      lineup2: players[11].id,
      lineup3: players[10].id,
      lineup4: players[9].id,
      lineup5: players[8].id,
      lineup6: players[7].id,
      lineup7: players[6].id,
      lineup8: players[5].id,
      lineup9: players[4].id,
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
