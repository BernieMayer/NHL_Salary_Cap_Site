class PlayersController < ApplicationController
  def index
    @players = Player.all
  end

  def show
    @player = Player.find_by(name: convert_param_name_to_database_name(params[:name]))
  end

  private def convert_param_name_to_database_name(name)
    url_name = name
    database_name = url_name.split("-").map(&:capitalize).join(" ")
    return database_name
  end
end
