require 'spec_helper'

describe Team do
  it "has a valid factory" do
    expect(FactoryGirl.build(:team)).to be_valid
  end
  it "is invalid without a name" do
    expect(FactoryGirl.build(:team, name: nil)).to_not be_valid
  end
  it "is invalid without a city" do
    expect(FactoryGirl.build(:team, name: nil)).to_not be_valid
  end
  it "should have 13 players" do
    team = FactoryGirl.create(:team_with_players)
    expect(team.players.length).to eq(13)
  end
end
