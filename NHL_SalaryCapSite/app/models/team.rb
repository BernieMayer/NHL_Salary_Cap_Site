class Team < ApplicationRecord
    has_many :players
    has_many :cap_hits, through: :players
    validates :name, presence: true
    validates :code, presence: true, length: { is: 3 }, uniqueness: true
end
