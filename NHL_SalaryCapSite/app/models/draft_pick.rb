class DraftPick < ApplicationRecord
  belongs_to :original_team, class_name: 'Team'
  belongs_to :current_team, class_name: 'Team'

  validates :year, presence: true
  validates :round, presence: true

  def swap_original_and_current_team
    self.original_team, self.current_team = self.current_team, self.original_team
    save!
  end
end
