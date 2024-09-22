# frozen_string_literal: true

class CapTableComponent < ViewComponent::Base
    attr_reader :players

    def initialize(team:, players:, cap_type: 'Roster')
        @team = team
        @players = players
        @cap_type = cap_type
    end

    def get_cap_hit(player, year)
        if @cap_type == "Buyout"
            1234
        else 
            player.cap_hit_for_team_in_season(@team, "#{year}-#{(year + 1).to_s[-2..]}")
        end  
    end
end
