# frozen_string_literal: true

class TeamDraftPicksComponent < ViewComponent::Base
  def initialize(team:)
    @team = team
    @draft_picks_by_year_and_round = @team.draft_picks_by_year_and_round
  end

  def draft_picks
    @team.draft_picks
  end
end
