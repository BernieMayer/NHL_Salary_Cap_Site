class Player < ApplicationRecord
    belongs_to :team

    validates :name, presence: true
    validates :team, presence: true
    validates :position, presence: true
end
