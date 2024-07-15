class Player < ApplicationRecord
    has_many :cap_hits, dependent: :destroy
    belongs_to :team

    validates :name, presence: true
    validates :team, presence: true
    validates :position, presence: true

    scope :forwards, -> { where(position: ["C", "LW", "RW"]) }
    scope :defence, -> { where(position: ["D", "LD", "RD"]) }
end
