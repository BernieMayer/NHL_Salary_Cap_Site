class Buyout < ApplicationRecord
  belongs_to :contract
  belongs_to :team

  scope :season, ->(season) { where(season: season) }

  def self.get_buyout_for_season(season, team, player)
    team.buyouts.season(season)
    .joins(:contract)
    .where(contracts: { player_id: player.id })
    .first
  end
end