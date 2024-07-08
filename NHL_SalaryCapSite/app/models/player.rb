class Player < ApplicationRecord
    validates :name, presence: true
    validates :team, presence: true
    validates :position, presence: true
end
