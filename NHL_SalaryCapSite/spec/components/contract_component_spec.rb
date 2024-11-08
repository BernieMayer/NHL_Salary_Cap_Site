# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContractComponent, type: :component do

  it 'renders something useful' do
   
    rendered_component = render_inline(ContractComponent.new)

    expect(rendered_component.to_html).to include('Cap Hit')
    expect(rendered_component.to_html).to include('AAV')
    expect(rendered_component.to_html).to include('Base')
    expect(rendered_component.to_html).to include('Signing Bonus')
    expect(rendered_component.to_html).to include('Minors Salary')

  end
end
