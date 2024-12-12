class TeamsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  def index
    @teams = Team.all
  end


  def search
    query = params[:query]
    teams_search_results = Team.where("name ILIKE ?", "%#{query}%")
                               .select(:id, :name, :code)
                               .map do |team|
                                 {
                                   id: team.id,
                                   name: team.name,
                                   code: team.code,
                                   url: Rails.application.routes.url_helpers.team_path(team.code)
                                 }
                               end
    
    render json: teams_search_results
    
  end

  def show
    @team = Team.find_by!(code: params[:code]) 
    @players = @team.players.roster.includes(:cap_hits)
    @salary_cap_total_2024 = @team.salary_cap_totals.find_by(year:2024).total
    @salary_cap_space_current_year = @team.salary_cap_totals.year(2024).first.calculate_cap_space
    

    @seasons = ["2024-25", "2025-26", "2026-27", "2027-28", "2028-29", "2029-30"]
    @table_headers = ["Player name", "Position"] + @seasons
                       

    @forwards = @players.forwards
    @forwards_data = @forwards.cap_hits_ordered_by_current_season(@team, @seasons)
    # @forwards_rows = format_results(@forwards.cap_hits_ordered_by_current_season(@team, seasons), seasons)
    
    @defence = @players.defence
    @defence_data = @defence.cap_hits_ordered_by_current_season(@team, @seasons)
    # @defence_rows = format_results(@defence.cap_hits_ordered_by_current_season(@team, seasons), seasons)

    @goalies = @players.goalies
    @goalies_data = @goalies.cap_hits_ordered_by_current_season(@team, @seasons)


    @buyout_players = @team.buyout_players
    @buyout_players_data = @team.buyout_players.buyout_cap_hits_ordered_by_current_season(@team, @seasons)

    @retained_players = @team.retained_players
    @retained_players_data = @retained_players.cap_hits_ordered_by_current_season(@team, @seasons)
  end

  def format_results(results, seasons)
    formatted_results = results.map do |record|
      [record.name, record.position] +
      seasons
          .filter { |season| record.attributes[season] > 0 }
          .map { |season| number_to_currency(record.attributes[season]) }
      
    end
    return formatted_results
  end
end
