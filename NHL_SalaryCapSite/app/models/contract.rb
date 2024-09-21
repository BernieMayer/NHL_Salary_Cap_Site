class Contract < ApplicationRecord
  belongs_to :player
  has_many :contract_details, dependent: :destroy
  has_many :salary_retentions, dependent: :destroy
  has_many :buyouts, dependent: :destroy
end
