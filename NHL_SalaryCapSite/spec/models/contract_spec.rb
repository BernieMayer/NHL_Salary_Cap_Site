require 'rails_helper'

RSpec.describe Contract, type: :model do
  it { should belong_to(:player) }
  it { should have_many(:contract_details).dependent(:destroy) }
end
