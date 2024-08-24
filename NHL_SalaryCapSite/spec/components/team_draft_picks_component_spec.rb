require 'rails_helper'

RSpec.describe TeamDraftPicksComponent, type: :component do
  let!(:team) { Team.create(name:"Calgary Flames", code: "CGY") }
  
  it "renders the draft picks table" do
    render_inline(TeamDraftPicksComponent.new(team: team))

    expect(rendered_component).to have_text("Round 1")
    expect(rendered_component).to have_text("Round 4")
    expect(rendered_component).to have_text("2025")

  end
end