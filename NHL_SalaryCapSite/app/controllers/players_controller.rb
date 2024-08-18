class PlayersController < ApplicationController
  def index
    @players = Player.all
    @free_agents = Player.free_agents
  end
end
