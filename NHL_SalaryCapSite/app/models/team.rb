class Team < ApplicationRecord
    has_many :players
    has_many :cap_hits, through: :players
    has_many :salary_cap_totals
    
    validates :name, presence: true
    validates :code, presence: true, length: { is: 3 }, uniqueness: true

    def buyout_players
        Player.joins(:cap_hits).where(cap_hits: { team_id: self.id, cap_type: 'Buyout' }).distinct
    end

    def retained_players
        Player.joins(:cap_hits).where(cap_hits: { team_id: self.id, cap_type: 'Retained'}).distinct
    end
end
