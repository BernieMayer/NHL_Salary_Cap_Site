class Player < ApplicationRecord
    has_many :cap_hits, dependent: :destroy
    has_many :contracts
    belongs_to :team, optional: true

    validates :name, presence: true

    ROSTER = "Roster"
    NON_ROSTER = "Non-Roster"
    MINOR = "Minor"
    IR = "IR"
    RETIRED = "Retired"
    
    STATUSES = [ROSTER, MINOR,  NON_ROSTER, IR, RETIRED]
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

    def self.buyout_cap_hits_ordered_by_current_season(team, seasons)
        select_statements = seasons.map do |season|
            "MAX(CASE WHEN buyouts.season = '#{season}' THEN buyouts.cap_hit ELSE 0 END) AS \"#{season}\""
        end
        
        results = self
            .joins(contracts: :buyouts)
            .select("players.name, players.position", *select_statements)
            .where("buyouts.team_id = ?", team.id)
            .group("players.name", "players.position")
            .order(Arel.sql("\"#{seasons[0]}\" DESC")) # Order by the first season's cap hit in descending order
        
        formatted_results = results.map do |record|
            [record.name, record.position] +
            seasons
                .filter { |season| record.attributes[season] > 0 }
                .map { |season| number_to_currency(record.attributes[season]) }
        end
        
        return formatted_results
    end
          

    
    def self.cap_hits_ordered_by_current_season(team, seasons)


        select_statements = seasons.map do |season|
          "MAX(CASE WHEN contract_details.season = '#{season}' THEN COALESCE(salary_retentions.retained_cap_hit, contract_details.cap_hit) ELSE 0 END) AS \"#{season}\""
        end
        
        results = self
          .left_joins(contracts: :contract_details)
          .left_joins(contracts: :salary_retentions)
          .select("players.name, players.position", *select_statements)
          .where("salary_retentions.team_id = ? OR salary_retentions.team_id IS NULL", team.id)
          .group("players.name", "players.position")
          .order(Arel.sql("\"#{seasons[0]}\" DESC")) # Order by the first season's cap hit in descending order
        
        
        
          formatted_results = results.map do |record|
            [record.name, record.position] +
            seasons
                .filter { |season| record.attributes[season] > 0 }
                .map { |season| number_to_currency(record.attributes[season]) }
          end
        
          return formatted_results 
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
