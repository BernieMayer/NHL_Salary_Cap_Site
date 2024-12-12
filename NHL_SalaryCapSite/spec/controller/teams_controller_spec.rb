require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  describe "GET index" do
    it "assigns @teams" do
      team = Team.create(name: "Calgary Flames", code: "CGY")
      get :index
      expect(assigns(:teams)).to eq([team])
    end
  end

  describe 'GET #search' do
    let!(:team1) { Team.create!(name: 'Cat Team', code: 'CAT') }
    let!(:team2) { Team.create!(name: 'Cats United', code: 'CTU') }
    let!(:team3) { Team.create!(name: 'Dog Squad', code: 'DOG') }

    context 'when query matches team names' do
      it 'returns matching teams' do
        get :search, params: { query: 'cat' }

        # Check that the response is successful
        expect(response).to have_http_status(:success)

        # Parse the JSON response
        json = JSON.parse(response.body)

        # Ensure the JSON contains only the matching teams
        expect(json.size).to eq(2)
        expect(json.map { |team| team['name'] }).to contain_exactly('Cat Team', 'Cats United')

        # Ensure each team has the expected fields and the URL is correct
        json.each do |team|
          expect(team).to have_key('id')
          expect(team).to have_key('name')
          expect(team).to have_key('code')
          expect(team).to have_key('url')
          
          # Validate that the URL is correctly formed using the team's code
          expect(team['url']).to include(team['code'])
          
        end
      end
    end

    context 'when query does not match any team' do
      it 'returns an empty array' do
        get :search, params: { query: 'nonexistent' }

        # Check that the response is successful
        expect(response).to have_http_status(:success)

        # Parse the JSON response
        json = JSON.parse(response.body)

        # Ensure the JSON is empty
        expect(json).to be_empty
      end
    end

    context 'when query is empty' do
      it 'returns an empty array' do
        get :search, params: { query: '' }

        # Check that the response is successful
        expect(response).to have_http_status(:success)

        # Parse the JSON response
        json = JSON.parse(response.body)

        # Ensure the JSON is empty
        expect(json).to be_empty
      end
    end
end

  describe "Show index" do
    let!(:team) { Team.create(name: "Calgary Flames", code: "CGY")}
    let!(:salary_cap_total) { SalaryCapTotal.create(team: team, total: 1000, year: 2024)}
    it "assigns @table_headers" do
      get :show, params: { code: "CGY" }
      expect(assigns(:table_headers)).to include("Player name", "Position", "2024-25")
    end
  end
end