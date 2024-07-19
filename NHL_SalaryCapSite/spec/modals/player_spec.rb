require 'rails_helper'

RSpec.describe Player, type: :model do

    describe "validates" do
        describe "no team required" do
            let!(:player) {Player.create(name: "Jake Smith", position: "LW")}

            it { expect(player).to be_valid }
        end

        describe "no position required" do
            describe "no position required" do
                let!(:player) {Player.create(name: "Jake Smith")}

                it { expect(player).to be_valid }
            end
        end
    end

    describe 'status' do
        let!(:team) { Team.create(name:"Calgary Flames", code: "CGY") }
        let!(:player) { Player.create(name: "Jake Bean", position: "LW", team: team, status: Player::ROSTER) }
    
        it 'has a valid status' do
            expect(player.status).to eq("Roster")
        end
    
        it 'can change status to Non-Roster' do
            player.update(status: Player::NON_ROSTER)
            expect(player.status).to eq("Non-Roster")
        end
    
        it 'can change status to IR' do
            player.update(status: Player::IR)
            expect(player.status).to eq("IR")
        end
    end

    describe '#forwards' do
        let!(:team) { Team.create(name:"Calgary Flames", code: "CGY") }
        let!(:forward1) { Player.create(name: "Blake Coleman", position: 'C', team: team) }
        let!(:forward2) { Player.create(name: "Ryan Lomberg", position: 'LW', team: team) }
        let!(:forward3) { Player.create(name: "Matt Coronato", position: 'RW', team: team) }
        let!(:forward4) { Player.create(name: "Jonathan Huberdeau", position: "LW, RW", team: team)}
        let!(:defenseman) { Player.create(name: "Jake Bean", position: 'D', team: team) }
        let!(:goalie) { Player.create(name: "Dustin Wolf", position: 'G', team: team) }

        it 'returns only the forwards' do
            expect(Player.forwards).to match_array([forward1, forward2, forward3, forward4])
        end
    end

    describe "#defence" do
        let!(:team) { Team.create(name:"Calgary Flames", code: "CGY") }
        let!(:forward1) { Player.create(name: "Blake Coleman", position: 'C', team: team) }
        let!(:forward2) { Player.create(name: "Ryan Lomberg", position: 'LW', team: team) }
        let!(:forward3) { Player.create(name: "Matt Coronato", position: 'RW', team: team) }
        let!(:defenseman) { Player.create(name: "Jake Bean", position: 'D', team: team) }
        let!(:defenseman1) { Player.create(name: "Kevin Bahl", position: "LD", team: team)}
        let!(:defenseman2) { Player.create(name: "Hunter Brzustewicz", position: "RD", team: team)}
        let(:defenseman3) { Player.create(name: "John Doe", position:"LD, RD, D", team: team)}
        let!(:goalie) { Player.create(name: "Dustin Wolf", position: 'G', team: team) }

        it 'returns only the defence' do
            expect(Player.defence).to match_array([defenseman, defenseman1, defenseman2, defenseman3])
        end
    end

    describe "#goalies" do
        let!(:team) { Team.create(name:"Calgary Flames", code: "CGY") }
        let!(:forward1) { Player.create(name: "Blake Coleman", position: 'C', team: team) }
        let!(:forward2) { Player.create(name: "Ryan Lomberg", position: 'LW', team: team) }
        let!(:forward3) { Player.create(name: "Matt Coronato", position: 'RW', team: team) }
        let!(:defenseman) { Player.create(name: "Jake Bean", position: 'D', team: team) }
        let!(:defenseman1) { Player.create(name: "Kevin Bahl", position: "LD", team: team)}
        let!(:defenseman2) { Player.create(name: "Hunter Brzustewicz", position: "RD", team: team)}
        let!(:goalie) { Player.create(name: "Dustin Wolf", position: 'G', team: team) }
        let!(:goalie1) { Player.create(name: "Dan Vladar", position: 'G', team: team) }

        it 'returns only the goalies' do
            expect(Player.goalies).to match_array([goalie, goalie1])
        end

    end
end