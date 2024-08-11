# frozen_string_literal: true

require "rails_helper"

RSpec.describe FreeAgentComponent, type: :component do
  it "renders the title" do
    render_inline(FreeAgentComponent.new)

    expect(page).to have_text "Free Agents"
  end
end
