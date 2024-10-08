class DraftPick < ApplicationRecord
  belongs_to :original_team, class_name: 'Team'
  belongs_to :current_team, class_name: 'Team'

  validates :year, presence: true
  validates :round, presence: true
end
