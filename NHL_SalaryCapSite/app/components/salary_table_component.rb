# frozen_string_literal: true

class SalaryTableComponent < ViewComponent::Base
  include ComponentsHelper
  include Components::TableHelper

  def initialize(seasons:, player_data:)
    @seasons = seasons
    @player_data = player_data
  end
end
