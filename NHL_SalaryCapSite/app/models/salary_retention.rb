class SalaryRetention < ApplicationRecord
  belongs_to :contract
  belongs_to :team

  def self.retention_for_season_and_team(season, team)
    SalaryRetention.all
    .where(team: team)
    .where(season: season)
  end
end