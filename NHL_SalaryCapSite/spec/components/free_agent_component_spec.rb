# frozen_string_literal: true

require "rails_helper"

RSpec.describe FreeAgentComponent, type: :component do
  it "renders the title" do
    render_inline(FreeAgentComponent.new(players: nil))

    expect(page).to have_text "Free Agents"
  end

  describe "with free agents" do
    let!(:free_agent_1) { Player.create(name: "Jake Smith", position: "LW") }

    it "should display the free agent" do
      render_inline(FreeAgentComponent.new(players: Player.free_agents))

      expect(page).to have_text "Jake Smith"
    end
  end
end
