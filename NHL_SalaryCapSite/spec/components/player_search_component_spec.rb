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
end
