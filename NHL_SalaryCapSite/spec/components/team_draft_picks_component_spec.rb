require 'rails_helper'

RSpec.describe TeamDraftPicksComponent, type: :component do
  let!(:team) { Team.create(name:"Calgary Flames", code: "CGY") }

  it "renders the draft picks table" do
    rendered_component = render_inline(TeamDraftPicksComponent.new(team: team))

    expect(rendered_component.text).to include("Round 1")
    expect(rendered_component.text).to include("Round 4")
    expect(rendered_component.text).to include("2025")

  end
end