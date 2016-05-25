require 'faker'

FactoryGirl.define do

  factory :player do |player|
    team
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    age { rand(17..40) }
    height { rand(66..78) }
    weight { rand(160..300) }
    position { ['P','C','1B','2B','3B','SS','LF','CF','RF'].sample }
    salary { rand(500000..20000000) }
    power { rand(1..100) }
    contact { rand(1..100) }
    speed { rand(1..100) }
    patience { rand(1..100) }
    plate_vision { rand(1..100) }
    pull_amount { rand(1..100) }
    uppercut_amount { rand(1..100) }
    batting_average { rand(1..100) }
    movement { rand(1..100) }
    control { rand(1..100) }
    location { rand(1..100) }
    agility { rand(1..100) }
    reactionTime { rand(1..100) }
    armStrength { rand(1..100) }
    fieldGrounder { rand(1..100) }
    fieldLiner { rand(1..100) }
    fieldFlyball { rand(1..100) }
    fieldPopup { rand(1..100) }
    throwShort { rand(1..100) }
    throwMedium { rand(1..100) }
    throwLong { rand(1..100) }
    intelligence { rand(1..100) }
    endurance { rand(1..100) }

  end

end
