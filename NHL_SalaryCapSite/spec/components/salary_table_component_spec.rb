require 'rails_helper'

RSpec.describe SalaryTableComponent, type: :component do
  include Rails.application.routes.url_helpers

  let!(:player) { Player.create(name: "John Doe", position: "C", slug: "john-doe")}
  let!(:player_data ) { [player]}
  let!(:seasons) { (2024..2030).to_a }

  it 'renders something useful' do
   
    rendered_component = render_inline(SalaryTableComponent.new(seasons: seasons, player_data: player_data))

    expect(rendered_component.to_html).to include('John Doe') # Check that it renders something useful
  end

  it 'renders a link for the player using LinkComponent' do
    rendered_component = render_inline(SalaryTableComponent.new(seasons: seasons, player_data: player_data))


    expect(page).to have_selector("a")
  end
end

