# frozen_string_literal: true

class FreeAgentComponent < ViewComponent::Base
  def initialize(players:)
    @players = players
  end
end
