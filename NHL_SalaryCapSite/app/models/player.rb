class Player < ApplicationRecord
    has_many :cap_hits, dependent: :destroy
    belongs_to :team

    validates :name, presence: true
    validates :team, presence: true
    validates :position, presence: true
end
