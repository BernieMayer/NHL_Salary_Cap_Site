# frozen_string_literal: true

class TeamDraftPicksComponent < ViewComponent::Base
  def initialize(team:)
    @team = team
  end

  def draft_picks
    @team.draft_picks
  end
end
