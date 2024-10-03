require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  describe "GET index" do
    it "assigns @teams" do
      team = Team.create(name: "Calgary Flames", code: "CGY")
      get :index
      expect(assigns(:teams)).to eq([team])
    end
  end
end