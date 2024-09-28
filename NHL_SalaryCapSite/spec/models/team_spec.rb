require 'rails_helper'

RSpec.describe Team, type: :model do

  describe '#draft_picks_by_year_and_round' do
    let!(:team1) { Team.create(name: "Test Team 1", code:"ABC") }
    let!(:team2) { Team.create(name: "Test Team 2", code: "ABD") }

    let!(:draft_picks) do
      [
        DraftPick.create(year: 2024, round: 1, original_team: team1, current_team: team2),
        DraftPick.create(year: 2024, round: 2, original_team: team1, current_team: team2),
        DraftPick.create(year: 2025, round: 1, original_team: team2, current_team: team1),
        DraftPick.create(year: 2025, round: 2, original_team: team1, current_team: team2),
        DraftPick.create(year: 2025, round: 1, original_team: team1, current_team: team2) # Duplicate entry for verification
      ]
    end
 

    it 'returns a nested hash grouped by year and round' do
      expected_result = {
        2024 => {
          1 => [DraftPick.find_by(year: 2024, round: 1, original_team: team1, current_team: team2)],
          2 => [DraftPick.find_by(year: 2024, round: 2, original_team: team1, current_team: team2)]
        },
        2025 => {
          1 => [
            DraftPick.find_by(year: 2025, round: 1, original_team: team2, current_team: team1),
            DraftPick.find_by(year: 2025, round: 1, original_team: team1, current_team: team2)
          ],
          2 => [DraftPick.find_by(year: 2025, round: 2, original_team: team1, current_team: team2)]
        }
      }
      
      expect(team1.draft_picks_by_year_and_round).to eq(expected_result)
    end

    it 'returns an empty hash if no draft picks exist' do
      team_without_picks = Team.create(name: "Empty Team", code: "ETM")
      
      expect(team_without_picks.draft_picks_by_year_and_round).to eq({})
    end

    it 'correctly handles a case where only one draft pick exists' do
      single_pick_team = Team.create(name: "Single Pick Team", code: "SPT")
      another_team = Team.create(name: "Another Team", code: "ATA")
      DraftPick.create(year: 2024, round: 1, original_team: single_pick_team, current_team: another_team)
      
      expected_result = {
        2024 => {
          1 => [DraftPick.find_by(year: 2024, round: 1, original_team: single_pick_team, current_team: another_team)]
        }
      }
      
      expect(single_pick_team.draft_picks_by_year_and_round).to eq(expected_result)
    end
  end

  describe '#retained_players' do
    it 'returns players with salary retention not playing for the team' do
      team = Team.create(name: 'Team Retaining Salary', code: "TRS")
      other_team = Team.create(name: 'Other Team', code: "OTT")

      player_on_other_team = Player.create(name: 'Player On Other Team', team: other_team)
      player_on_team = Player.create(name: 'Player On Same Team', team: team)

      contract_with_retention = Contract.create(player: player_on_other_team)
      contract_on_team = Contract.create(player: player_on_team)

      SalaryRetention.create(contract: contract_with_retention, team: team, retained_cap_hit: 50.0, retention_percentage: 0.50)
      SalaryRetention.create(contract: contract_on_team, team: team, retained_cap_hit: 50.0, retention_percentage: 0.50)
      result = team.retained_players

      expect(result).to include(player_on_other_team)

      expect(result).not_to include(player_on_team)
    end
  end

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