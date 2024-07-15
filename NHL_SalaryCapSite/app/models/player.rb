class Player < ApplicationRecord
    has_many :cap_hits, dependent: :destroy
    belongs_to :team

    validates :name, presence: true
    validates :team, presence: true
    validates :position, presence: true

    scope :forwards, -> { where("LOWER(position) LIKE '%c%' OR LOWER(position) LIKE '%lw%' OR LOWER(position) LIKE '%rw%'") }
    scope :defence, -> {where("LOWER(position) LIKE '%d%' OR LOWER(position) LIKE '%ld%' OR LOWER(position) LIKE '%rd%'") }
    scope :goalies, -> { where(position: ["G"])}
end
