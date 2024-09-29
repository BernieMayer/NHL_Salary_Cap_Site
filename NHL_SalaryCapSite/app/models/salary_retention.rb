class SalaryRetention < ApplicationRecord
  belongs_to :contract
  belongs_to :team

  scope :season, ->(season) { where(season: season) }
end