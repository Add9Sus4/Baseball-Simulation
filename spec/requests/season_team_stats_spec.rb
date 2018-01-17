require 'rails_helper'

RSpec.describe "SeasonTeamStats", type: :request do
  describe "GET /season_team_stats" do
    it "works! (now write some real specs)" do
      get season_team_stats_path
      expect(response).to have_http_status(200)
    end
  end
end
