# frozen_string_literal: true

require "test_helper"

RSpec.describe ContractComponent, type: :component do

  it 'renders something useful' do
   
    rendered_component = render_inline(ContractComponent.new)

  end
end
