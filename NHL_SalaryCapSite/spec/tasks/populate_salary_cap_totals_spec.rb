require 'rails_helper'
require 'rake'

describe 'salary_cap:populate' do
    before(:each) do
        # Clean up the database before each test
        Team.destroy_all
        Player.destroy_all
        CapHit.destroy_all
    
        Rake.application.load_rakefile
        Rake::Task['salary_cap:populate'].reenable
      end

    context "One cap hit" do
        let!(:team) { Team.create(name: "Calgary Flames", code: "CGY")}
        let!(:player) { Player.create(name: "Dustin Wolf", team: team, position: "G")}
        let!(:player_cap_hit) {  9000000.0}
        let!(:cap_hit) {CapHit.create(team_id: team.id, player_id: player.id, year: 2024, cap_value:player_cap_hit )}
        let!(:salary_cap_total) {SalaryCapTotal.create(team: team, year: 2024, total: 0.0)}

        it "the total should equal the cap hit" do
            
            Rake::Task['salary_cap:populate'].invoke
            
            expect(Player.all.count).to eq(1)
            expect(team.players.length).to eq(1)
            expect(SalaryCapTotal.find_by(team: team).total).to eq(player_cap_hit)
        end
    end

    context "Multiple players" do 
        let!(:team) { Team.create(name: "Calgary Flames", code: "CGY")}
        let!(:player) { Player.create(name: "Dustin Wolf", team: team, position: "G") }
        let!(:player_2) { Player.create(name: "Blake Coleman", team: team, position: "C") }
        let!(:player_3) { Player.create(name: "Kevin Bahl", team: team, position: "D") }
        let!(:player_cap_hit) {  9000000.0 }
        let!(:blake_coleman_cap_hit) {43000000.0 }
        let!(:kevin_bahl_cap_hit) {10000000.0 }
        let!(:cap_hit) { CapHit.create(team_id: team.id, player_id: player.id, year: 2024, cap_value: player_cap_hit )}
        let!(:cap_hit_1) { CapHit.create(team_id: team.id, player_id: player_2.id, year: 2024, cap_value: blake_coleman_cap_hit)}
        let!(:cap_hit_2) { CapHit.create(team_id: team.id, player_id: player_3.id, year: 2024, cap_value: kevin_bahl_cap_hit )}
        let!(:salary_cap_total) {SalaryCapTotal.create(team: team, year: 2024, total: 0.0)}
        let!(:expected_cap_hit) {62000000.0}

        it "the total should equal the cap hit sum" do
            
            Rake::Task['salary_cap:populate'].invoke
            

            expect(Player.all.count).to eq(3)
            expect(team.players.length).to eq(3)
            expect(CapHit.all.count).to eq(3)
           
            
            expect(SalaryCapTotal.find_by(team: team).total).to eq(expected_cap_hit)
        end
    end     
end
