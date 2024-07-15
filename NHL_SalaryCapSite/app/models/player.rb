class Player < ApplicationRecord
    has_many :cap_hits, dependent: :destroy
    belongs_to :team

    validates :name, presence: true
    validates :team, presence: true
    validates :position, presence: true

    ROSTER = "Roster"
    NON_ROSTER = "Non-Roster"
    IR = "IR"
    
    STATUSES = [ROSTER, NON_ROSTER, IR]
    validates :status, inclusion: { in: STATUSES }

    scope :forwards, -> { where("LOWER(position) LIKE '%c%' OR LOWER(position) LIKE '%lw%' OR LOWER(position) LIKE '%rw%'") }
    scope :defence, -> {where("LOWER(position) LIKE '%d%' OR LOWER(position) LIKE '%ld%' OR LOWER(position) LIKE '%rd%'") }
    scope :goalies, -> { where(position: ["G"])}

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
