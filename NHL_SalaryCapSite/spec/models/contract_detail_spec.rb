require 'rails_helper'

RSpec.describe ContractDetail, type: :model do
  it { should belong_to(:contract) }
end
