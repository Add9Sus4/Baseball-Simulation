require 'rails_helper'

RSpec.describe "Drafts", type: :request do
  describe "GET /drafts" do
    it "works! (now write some real specs)" do
      get drafts_path
      expect(response).to have_http_status(200)
    end
  end
end
