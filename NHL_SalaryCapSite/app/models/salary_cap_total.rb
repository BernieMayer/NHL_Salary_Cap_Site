class SalaryCapTotal < ApplicationRecord
  belongs_to :team

  SALARY_CAP_2024 = 88000000

  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :year, presence: true, numericality: { only_integer: true, greater_than: 0 }

  scope :year, ->(year) { where(year: year) }

  def calculate_cap_space
    if self.year == 2024 
      SALARY_CAP_2024 - self.total
    end
  end
end
