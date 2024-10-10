# frozen_string_literal: true

class SalaryTableComponent < ViewComponent::Base
  include ComponentsHelper
  include Components::TableHelper
 
  def initialize(headers:, rows:)
    @headers = headers
    @rows = rows
  end
end
