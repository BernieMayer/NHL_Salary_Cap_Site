class TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def show
    @team = Team.find_by!(code: params[:code]) 
    @players = @team.players.includes(:cap_hits)

    
  end
end
