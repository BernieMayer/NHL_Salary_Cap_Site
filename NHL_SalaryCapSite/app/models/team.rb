class Team < ApplicationRecord
    has_many :players
    has_many :cap_hits, through: :players
    has_many :buyouts
    has_many :salary_cap_totals
    has_many :original_draft_picks, class_name: 'DraftPick', foreign_key: 'original_team_id'
    has_many :current_draft_picks, class_name: 'DraftPick', foreign_key: 'current_team_id'
    has_many :salary_retentions, dependent: :destroy
    
    validates :name, presence: true
    validates :code, presence: true, length: { is: 3 }, uniqueness: true

    def draft_picks
        DraftPick.where('original_team_id = ? OR current_team_id = ?', id, id)
    end

    def draft_picks_by_year_and_round
        DraftPick
          .where("original_team_id = ? OR current_team_id = ?", self.id, self.id)
          .each_with_object({}) do |draft_pick, hash|
            year = draft_pick.year
            round = draft_pick.round
    
            hash[year] ||= {}
            hash[year][round] ||= []
            hash[year][round] << draft_pick
          end
    end


    def buyout_players
        Player.joins(contracts: :buyouts).where(buyouts: { team_id: self.id})
                            .where(contracts: { player_id: Player.where(team_id: id) }).distinct
    end

    def retained_players
        Player.joins(contracts: :salary_retentions)
                         .where(salary_retentions: { team_id: id })
                         .where.not(contracts: { player_id: Player.where(team_id: id) }).distinct
    end
end
