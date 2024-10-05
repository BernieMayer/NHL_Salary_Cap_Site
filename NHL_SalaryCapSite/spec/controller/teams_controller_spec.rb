require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  describe "GET index" do
    it "assigns @teams" do
      team = Team.create(name: "Calgary Flames", code: "CGY")
      get :index
      expect(assigns(:teams)).to eq([team])
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