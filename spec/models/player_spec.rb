require 'spec_helper'

describe Player do
  it "has a valid factory" do
    expect(FactoryGirl.build(:player)).to be_valid
  end
  it "is invalid without a firstname" do
    expect(FactoryGirl.build(:player, first_name: nil)).to_not be_valid
  end
  it "is invalid without a lastname" do
    expect(FactoryGirl.build(:player, last_name: nil)).to_not be_valid
  end
end
