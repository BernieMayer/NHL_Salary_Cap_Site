class CapHit < ApplicationRecord
    belongs_to :team
    belongs_to :player
  
    validates :cap_value, presence: true
    validates :year, presence: true

    ROSTER = "Roster"
    RETAINED = "Retained"
    BUYOUT = "Buyout"
    BURIED = "Buried"    

    TYPES = [ROSTER, RETAINED,  BUYOUT, BURIED]

    scope :buyout, -> { where(cap_type: 'Buyout') }
    scope :retained, -> { where(cap_type: 'Retained')}
end