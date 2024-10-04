require 'rails_helper'

RSpec.describe TableComponent, type: :component do
  it "renders something useful" do
    headers = ["Player", "Position"]
    rows = [["Jack Eichel", "C"], ["Victor Hedman", "D"]]
    render_inline(TableComponent.new(headers: headers, rows: rows))
    expect(rendered_content).to include("Player")
    expect(rendered_content).to include("Jack Eichel")
  end
end
