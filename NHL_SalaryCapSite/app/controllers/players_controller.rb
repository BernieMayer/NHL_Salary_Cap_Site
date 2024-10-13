class PlayersController < ApplicationController
  def index
    @players = Player.all
  end

  def show
    @player = Player.find_by(slug: params[:slug])

    if @player.nil?
      render status: :not_found, json: { error: "Player not found" }
    end
  end

  private def convert_param_name_to_database_name(name)
    url_name = name
    database_name = url_name.split("-").map(&:capitalize).join(" ")
    return database_name
  end
end
