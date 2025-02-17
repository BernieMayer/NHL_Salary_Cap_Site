class TradeAnalyzerController < ApplicationController
  def index
    @teams = Team.all.order(:name)
  end

  def get_players
    team = Team.find(params[:team_id])
    @players = team.players.order(:name)
    
    render partial: 'player_list', locals: { players: @players }
  end

  def get_draft_picks
    team = Team.find(params[:team_id])
    @draft_picks = team.current_draft_picks
    render partial: 'draft_picks', locals: { draft_picks: @draft_picks }
  end
end 