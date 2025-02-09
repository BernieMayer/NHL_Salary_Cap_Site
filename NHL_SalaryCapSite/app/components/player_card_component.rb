class PlayerCardComponent < ViewComponent::Base
  def initialize(player:)
    @player = player
  end

  private

  attr_reader :player
end 