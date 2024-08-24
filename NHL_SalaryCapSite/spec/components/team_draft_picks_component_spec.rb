require 'rails_helper'

RSpec.describe TeamDraftPicksComponent, type: :component do
  let!(:team) { Team.create(name:"Calgary Flames", code: "CGY") }

  it "renders the draft picks table" do
    rendered_component = render_inline(TeamDraftPicksComponent.new(team: team))

    expect(rendered_component.text).to include("Round 1")
    expect(rendered_component.text).to include("Round 4")
    expect(rendered_component.text).to include("2025")
  end
describe "when there are draft picks" do
    it "displays the correct draft pick counts for specific rows and columns" do
      team = Team.create!(name: "Test Team", code: "TTM")

      DraftPick.create!(year: 2025, round: 1, original_team: team, current_team: team)
      DraftPick.create!(year: 2025, round: 1, original_team: team, current_team: team)
      DraftPick.create!(year: 2025, round: 2, original_team: team, current_team: team)
  
      rendered_component = render_inline(TeamDraftPicksComponent.new(team: team))
  

      table = rendered_component.css('table')

       # Verify the number of draft picks for year 2024, round 1
      expect(table.css('tbody tr:nth-child(1) td:nth-child(2)').text.strip).to eq("2")

      # Verify the number of draft picks for year 2024, round 2
      expect(table.css('tbody tr:nth-child(1) td:nth-child(3)').text.strip).to eq("1")
  
      # Verify a cell with no draft picks (for example, year 2024, round 4)
      expect(table.css('tbody tr:nth-child(1) td:nth-child(4)').text.strip).to eq("0")
    end
  end
end