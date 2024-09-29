require 'rails_helper'

RSpec.describe SeasonContractDetailTableComponent, type: :component do
  it "renders something useful" do
    render_inline(SeasonContractDetailTableComponent.new)
    expect(rendered_content).to include("some expected output")
  end
end
