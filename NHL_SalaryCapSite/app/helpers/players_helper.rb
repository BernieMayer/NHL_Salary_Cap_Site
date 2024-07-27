module PlayersHelper
  def display_team_name(player)
   if player.team.nil?
      "Free Agent"
    else
      player.team.name
    end
  end
end
