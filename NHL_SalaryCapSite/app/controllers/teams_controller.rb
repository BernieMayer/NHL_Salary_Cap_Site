class TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def show
    @team = Team.find_by!(code: params[:code]) 
    @players = @team.players.roster.includes(:cap_hits)
    @salary_cap_total_2024 = @team.salary_cap_totals.find_by(year:2024).total
    

    @forwards = @players.forwards
    @defence = @players.defence
    @goalies = @players.goalies

    @buyout_players = @team.buyout_players
    @retained_players = @team.retained_players
  end
end
