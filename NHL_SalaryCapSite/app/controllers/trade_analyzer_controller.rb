class TradeAnalyzerController < ApplicationController
  def index
    @teams = Team.all.order(:name)
  end

  def get_players
    team = Team.find(params[:team_id])
    @players = team.players.order(:name)
    
    render partial: 'player_list', locals: { players: @players }
  end
end 