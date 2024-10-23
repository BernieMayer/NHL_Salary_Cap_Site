require 'rails_helper'

RSpec.describe "players/show.html.erb", type: :view do
  let(:team) { Team.create!(name: "Arizona Coyotes", code: "ARI") }
  let(:player) do
    Player.create!(
      name: "Connor Bedard",
      team: team,
      position: "Center",
      born: Date.new(2005, 7, 17),
      draft_details: "1st overall, 2023 NHL Draft",
      acquired: "Trade from Chicago"
    )
  end

  before do
    assign(:player, player)
    render
  end

  describe "it should be able to handle a player without a team" do
    let(:player) do
      Player.create!(
        name: "Kyle Clifford",
        position: "Center",
        born: Date.new(2005, 7, 17),
        draft_details: "1st overall, 2023 NHL Draft",
        acquired: "Trade from Chicago"
      )
    end

    it "displays free agent" do
      expect(rendered).to have_selector('h1', text: "Free Agent")
    end
  end

  it "displays the player's name" do
    expect(rendered).to have_selector('h1', text: player.name)
  end

  it "displays the player's team name with a link" do
    expect(rendered).to have_link(player.team.name, href: team_path(code: player.team.code))
  end

  it "displays the player's position" do
    expect(rendered).to have_selector('dd', text: player.position)
  end

  it "displays the player's birth date" do
    expect(rendered).to have_selector('dd', text: player.born.strftime("%B %d, %Y"))
  end

  it "displays the player's draft details" do
    expect(rendered).to have_selector('dd', text: player.draft_details)
  end

  it "displays the player's acquisition details" do
    expect(rendered).to have_selector('dd', text: player.acquired)
  end
end
