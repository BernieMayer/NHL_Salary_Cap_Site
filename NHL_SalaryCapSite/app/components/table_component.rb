class TableComponent < ViewComponent::Base
  def initialize(headers:, rows:)
    @headers = headers
    @rows = rows
  end
end
