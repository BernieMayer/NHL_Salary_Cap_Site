class CapHit < ApplicationRecord
    belongs_to :team
    belongs_to :player
  
    validates :cap_value, presence: true
    validates :year, presence: true
end
