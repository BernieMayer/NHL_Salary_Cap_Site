# frozen_string_literal: true

class CapTableComponent < ViewComponent::Base
    include SeasonHelper
    attr_reader :players

    def initialize(team:, players:, cap_type: 'Roster')
        @team = team
        @players = players
        @cap_type = cap_type
    end

    def get_cap_hit(player, year)
        if @cap_type == "Buyout"
            Buyout.get_buyout_for_season(format_year_to_season(year), @team, player)&.cap_hit
        else 
            player.cap_hit_for_team_in_season(@team, format_year_to_season(year))
        end  
    end
end
