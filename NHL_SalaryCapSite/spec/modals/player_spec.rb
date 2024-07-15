require 'rails_helper'

RSpec.describe Player, type: :model do

    describe '#forwards' do
        let!(:team) { Team.create(name:"Calgary Flames", code: "CGY") }
        let!(:forward1) { Player.create(name: "Blake Coleman", position: 'C', team: team) }
        let!(:forward2) { Player.create(name: "Ryan Lomberg", position: 'LW', team: team) }
        let!(:forward3) { Player.create(name: "Matt Coronato", position: 'RW', team: team) }
        let!(:defenseman) { Player.create(name: "Jake Bean", position: 'D', team: team) }
        let!(:goalie) { Player.create(name: "Dustin Wolf", position: 'G', team: team) }

        it 'returns only the forwards of the team' do
            expect(Player.forwards).to match_array([forward1, forward2, forward3])
        end
    end
end