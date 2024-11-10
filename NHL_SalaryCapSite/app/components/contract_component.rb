# frozen_string_literal: true

class ContractComponent < ViewComponent::Base
  include ComponentsHelper
  include Components::TableHelper

  def initialize(contract:)
    @contract_details = contract.contract_details
  end

end
