class Team < ApplicationRecord
    has_many :players
    has_many :cap_hits, through: :players
    has_many :salary_cap_totals
    has_many :original_draft_picks, class_name: 'DraftPick', foreign_key: 'original_team_id'
    has_many :current_draft_picks, class_name: 'DraftPick', foreign_key: 'current_team_id'
    
    validates :name, presence: true
    validates :code, presence: true, length: { is: 3 }, uniqueness: true

    def draft_picks
        DraftPick.where('original_team_id = ? OR current_team_id = ?', id, id)
    end

    def buyout_players
        Player.joins(:cap_hits).where(cap_hits: { team_id: self.id, cap_type: 'Buyout' }).distinct
    end

    def retained_players
        Player.joins(:cap_hits).where(cap_hits: { team_id: self.id, cap_type: 'Retained'}).distinct
    end
end
