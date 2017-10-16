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
    wins {0}
    losses {0}
    runs_scored {0}
    runs_allowed {0}
    schedule {"N/A"}
    streak {0}

    factory :team_with_players do
      after(:create) do |team|
        25.times do
          player = create(:player, :average, team: team)
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
        team.update_attributes(sp1: team.players[9].id)
        team.update_attributes(sp2: team.players[10].id)
        team.update_attributes(sp3: team.players[11].id)
        team.update_attributes(sp4: team.players[12].id)
        team.update_attributes(sp5: team.players[13].id)
        team.update_attributes(lr: team.players[14].id)
        team.update_attributes(mr1: team.players[15].id)
        team.update_attributes(mr2: team.players[16].id)
        team.update_attributes(mr3: team.players[17].id)
        team.update_attributes(su1: team.players[18].id)
        team.update_attributes(su2: team.players[19].id)
        team.update_attributes(cl: team.players[20].id)
        team.update_attributes(rotation_position: 1)
      end
    end

  end
end
