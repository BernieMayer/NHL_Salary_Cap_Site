class SalaryCapTotal < ApplicationRecord
  belongs_to :team

  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :year, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
