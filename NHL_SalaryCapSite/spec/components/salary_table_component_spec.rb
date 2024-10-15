require 'rails_helper'

RSpec.describe SalaryTableComponent, type: :component do
  it 'renders something useful' do
    seasons = (2024..2030).to_a # Example seasons data
    player_data = [Player.create(name: "John Doe", position: "C", slug: "john-doe")]

    # Initialize the component with the required keyword arguments
    rendered_component = render_inline(SalaryTableComponent.new(seasons: seasons, player_data: player_data))

    expect(rendered_component.to_html).to include('John Doe') # Check that it renders something useful
  end
end
