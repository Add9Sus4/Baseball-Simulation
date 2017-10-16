require 'spec_helper'

describe Game do

  before do
    Team.delete_all
    Player.delete_all

    @home_team = FactoryGirl.create(:team_with_players)
    @away_team = FactoryGirl.create(:team_with_players)
  end

  it 'should not create an error' do

    @game = Game.new(@home_team, @away_team, 0, 0)
    @game.play

    puts @game.play_by_play
  end

end
