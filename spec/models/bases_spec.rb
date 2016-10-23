require 'spec_helper'

describe Bases do

  before do
    @bases = Bases.new(@test_game)
  end

  it "should initially have no runners on base" do
    expect(@bases.runner_on_first).to be_nil
    expect(@bases.runner_on_second).to be_nil
    expect(@bases.runner_on_third).to be_nil
  end

  it "should initially have runs scored of 0" do
    expect(@bases.runs_scored).to equal(0)
  end

  it "should initially have a base status of empty" do
    expect(@bases.status).to equal(BaseStatus::EMPTY)
  end

  describe "#getRunsScored" do
    it "should return the number of runs scored" do
      @bases.runs_scored = 3
      expect(@bases.getRunsScored).to equal(3)
    end
  end

end
