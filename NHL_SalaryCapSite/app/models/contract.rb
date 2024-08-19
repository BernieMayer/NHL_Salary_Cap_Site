class Contract < ApplicationRecord
  belongs_to :player
  has_many :contract_details, dependent: :destroy
end
