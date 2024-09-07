class Player < ApplicationRecord
    has_many :cap_hits, dependent: :destroy
    has_many :contracts
    belongs_to :team, optional: true

    validates :name, presence: true

    ROSTER = "Roster"
    NON_ROSTER = "Non-Roster"
    MINOR = "Minor"
    IR = "IR"
    
    STATUSES = [ROSTER, MINOR,  NON_ROSTER, IR]
    validates :status, inclusion: { in: STATUSES }

    scope :forwards, -> { where("LOWER(position) LIKE '%c%' OR LOWER(position) LIKE '%lw%' OR LOWER(position) LIKE '%rw%'") }
    scope :defence, -> {where("LOWER(position) LIKE '%d%' OR LOWER(position) LIKE '%ld%' OR LOWER(position) LIKE '%rd%'") }
    scope :goalies, -> { where(position: ["G"])}


    def current_salary
        self.cap_hits.where(year: 2024).sum{ |cap_hit| cap_hit.cap_value }
    end

    def team_cap_hits
      self.cap_hits.where(team: self.team)
    end

    def cap_hit_for_team_in_season(team, season)
        ContractDetail
            .left_joins(contract: :salary_retentions)
            .where(contracts: { player_id: id })
            .where(contract_details: { season: season })
            .where("salary_retentions.team_id = ? OR salary_retentions.team_id IS NULL", team.id)
            .select("COALESCE(salary_retentions.retained_cap_hit, contract_details.cap_hit) AS cap_hit")
            .first
            &.cap_hit
    end


    def self.roster
        where(status: ROSTER)
    end

    def self.non_roster
        where(status: NON_ROSTER)
    end

    def self.ir
        where(status: IR)
    end

    def roster?
        status == ROSTER
    end

    def non_roster?
        status == NON_ROSTER
    end

    def ir?
        status == IR
    end
end
