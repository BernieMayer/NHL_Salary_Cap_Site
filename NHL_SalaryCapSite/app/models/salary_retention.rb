class SalaryRetention < ApplicationRecord
  belongs_to :contract
  belongs_to :team
end