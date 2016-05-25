require 'faker'

FactoryGirl.define do

  factory :team do
    city {Faker::Address.city}
    name {Faker::Team.creature.capitalize}
    league {["NL","AL"].sample}
    division {["East","Central","West"].sample}
    stadium {name + " " + ["Stadium","Field","Park","Coliseum","Center"].sample}
    capacity {45000}
    lineup1 {0}
    lineup2 {1}
    lineup3 {2}
    lineup4 {3}
    lineup5 {4}
    lineup6 {5}
    lineup7 {6}
    lineup8 {7}
    lineup9 {8}

    factory :team_with_players do
      after(:create) do |team|
        13.times do
          player = create(:player, team: team)
          player.set_initial_stats
        end
        team.update_attributes(catcher: team.players[0].id)
        team.update_attributes(designated_hitter: team.players[1].id)
        team.update_attributes(first_base: team.players[2].id)
        team.update_attributes(second_base: team.players[3].id)
        team.update_attributes(third_base: team.players[4].id)
        team.update_attributes(shortstop: team.players[5].id)
        team.update_attributes(left_field: team.players[6].id)
        team.update_attributes(center_field: team.players[7].id)
        team.update_attributes(right_field: team.players[8].id)
      end
    end

  end
end
