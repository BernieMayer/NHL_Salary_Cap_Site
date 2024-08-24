require 'rails_helper'

RSpec.describe Team, type: :model do

  describe "#draft_picks" do
    before do
      @team = Team.create!(name: "Team A", code: "AAA")
      @other_team = Team.create!(name: "Team B", code: "BBB")

      @draft_pick1 = DraftPick.create!(
        year: 2024,
        round: 1,
        original_team: @team,
        current_team: @other_team,
        isTradedAway: false,
        tradedDate: nil,
        conditions: "Conditional on playoffs"
      )

      @draft_pick2 = DraftPick.create!(
        year: 2025,
        round: 2,
        original_team: @other_team,
        current_team: @team,
        isTradedAway: true,
        tradedDate: Date.today,
        conditions: "Conditional on trade"
      )

      @draft_pick3 = DraftPick.create!(
        year: 2026,
        round: 3,
        original_team: @other_team,
        current_team: @other_team,
        isTradedAway: false,
        tradedDate: nil,
        conditions: "Conditional on injury"
      )
    end

    it "returns draft picks where the team is the original team" do
      expect(@team.draft_picks).to include(@draft_pick1)
    end

    it "returns draft picks where the team is the current team" do
      expect(@team.draft_picks).to include(@draft_pick2)
    end

    it "does not return draft picks where the team is neither the original nor current team" do
      expect(@team.draft_picks).not_to include(@draft_pick3)
    end

    it "returns the correct number of draft picks" do
      expect(@team.draft_picks.count).to eq(2)
    end
  end
    
end