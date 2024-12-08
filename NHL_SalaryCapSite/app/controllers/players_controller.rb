class PlayersController < ApplicationController
  def index
    @players = Player.roster.order(:name).paginate(page: params[:page], per_page: 50)
  end  

  def show
    @player = Player.find_by(slug: params[:slug])

    if @player.nil?
      render status: :not_found, json: { error: "Player not found" }
    end
  end

  def search
    query = params[:query]

    if query.blank?
      render json: []
      return
    end

    players = Player.where("name ILIKE ?", "%#{query}%").select(:id, :name, :slug)

    render json: players
  end

  private def convert_param_name_to_database_name(name)
    url_name = name
    database_name = url_name.split("-").map(&:capitalize).join(" ")
    return database_name
  end
end
