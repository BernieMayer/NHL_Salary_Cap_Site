class TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def show
    @team = Team.find_by!(code: params[:code]) 
    @players = @team.players.roster.includes(:cap_hits)
    @salary_cap_total_2024 = @team.salary_cap_totals.find_by(year:2024).total
    @salary_cap_space_current_year = @team.salary_cap_totals.year(2024).first.calculate_cap_space
    

    seasons = ["2024-25", "2025-26", "2026-27", "2027-28", "2028-29", "2029-30"]
    @table_headers = ["Player name", "Position"] + seasons
                       

    @forwards = @players.forwards
    @forwards_rows = @forwards.cap_hits_ordered_by_current_season(@team, seasons)
    
    @defence = @players.defence
    @defence_rows = @defence.cap_hits_ordered_by_current_season(@team, seasons)

    @goalies = @players.goalies
    @goalies_rows = @goalies.cap_hits_ordered_by_current_season(@team, seasons)

    @buyout_players = @team.buyout_players
    @buyout_players_rows = @team.buyout_players.buyout_cap_hits_ordered_by_current_season(@team, seasons)
    @retained_players = @team.retained_players
    @retained_players_rows = @retained_players.cap_hits_ordered_by_current_season(@team, seasons)
  end
end
