# frozen_string_literal: true

class CapTableComponent < ViewComponent::Base
    attr_reader :players

    def initialize(players:, cap_type: 'Roster')
        @players = players
        @cap_type = cap_type
    end

    def get_cap_hit(player, year)
        if @cap_type == "Roster" 
            player.team_cap_hits.find_by(year: year)&.cap_value
        elsif @cap_type == "Buyout"
            player.cap_hits.buyout.find_by(year: year)&.cap_value
        end
    end
end
