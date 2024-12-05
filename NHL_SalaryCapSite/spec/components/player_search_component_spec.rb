require 'rails_helper'

RSpec.describe PlayerSearchComponent, type: :component do
  let(:component) { described_class.new }

  it 'renders the search input field' do
    render_inline(component)
    expect(page).to have_selector('input.player-search-input')
  end

  it 'renders an empty results list initially' do
    render_inline(component)
    expect(page).to have_selector('ul#player-search-results', text: '')
  end

  it 'renders a list of players when search_players is called' do
    player1 = Player.create!(name: "Connor McDavid", slug: "connor-mcdavid")
    player2 = Player.create!(name: "Auston Matthews", slug: "auston-matthews")

    results = component.search_players('Connor')
    expect(results).to include([player1.id, "Connor McDavid", "connor-mcdavid"])
    expect(results).not_to include([player2.id, "Auston Matthews", "auston-matthews"])
  end

  it 'returns an empty array when the query is blank' do
    expect(component.search_players('')).to eq([])
    expect(component.search_players(nil)).to eq([])
  end
end
