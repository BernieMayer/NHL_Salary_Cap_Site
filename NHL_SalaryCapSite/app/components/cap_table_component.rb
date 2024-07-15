# frozen_string_literal: true

class CapTableComponent < ViewComponent::Base
    attr_reader :players

    def initialize(players:)
        @players = players
    end
end
