class Buyout < ApplicationRecord
  belongs_to :contract
  belongs_to :team

  def self.get_buyout_for_season(season, team, player)
    Buyout
    .joins(:contract)
    .where(team: team)
    .where(contracts: { player_id: player.id })
    .where(season: season)
    .first
  end

  def self.get_buyouts_for_team_season(season, team)
    Buyout
      .where(team: team)
      .where(season: season)
  end

end