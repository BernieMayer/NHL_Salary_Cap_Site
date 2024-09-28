require 'rails_helper'
require 'rake'

describe 'salary_cap:populate' do
    before(:each) do
        Rake.application.load_rakefile
        Rake::Task['salary_cap:populate'].reenable
    end

    context "One cap hit" do
        let!(:team) { Team.create(name: "Calgary Flames", code: "CGY")}
        let!(:player) { Player.create(name: "Dustin Wolf", team: team, position: "G")}
        let!(:player_cap_hit) { 9000000.0 }
        let!(:contract_detail) { create_contract_with_cap_hit(player_cap_hit,player, "2024-25") }
        let!(:salary_cap_total) {SalaryCapTotal.create(team: team, year: 2024, total: 0.0)}

        it "the total should equal the cap hit" do
            
            expect do
                Rake::Task['salary_cap:populate'].invoke
                salary_cap_total.reload
            end.to change { salary_cap_total.total}.from(0.0).to(player_cap_hit)
            
            expect(SalaryCapTotal.all.count).to eq(1)
            expect(Player.all.count).to eq(1)
            expect(team.players.length).to eq(1)
        end
    end

    context "Multiple teams" do
        let!(:team_1) { Team.create(name: "Calgary Flames", code: "CGY")}
        let!(:team_2) { Team.create(name: "Edmonton Oilers", code: "EDM")}
        let!(:player) { Player.create(name: "Dustin Wolf", team: team_1, position: "G")}
        let!(:player_cap_hit) { 9000000.0 }
        let!(:contract_detail) { create_contract_with_cap_hit(player_cap_hit,player, "2024-25") }
        let!(:salary_cap_total) {SalaryCapTotal.create(team: team_1, year: 2024, total: 0.0)}

        let!(:player_2) {Player.create(name: "Staurt Skinner", team: team_2, position: "G")}
        let!(:player_cap_hit_2) { 34000000.0 }
        let!(:contract_detail_2) { create_contract_with_cap_hit(player_cap_hit_2,player_2, "2024-25") }
        let!(:salary_cap_total_2) {SalaryCapTotal.create(team: team_2, year: 2024, total: 0.0)}

        
        it "the total should equal the cap hit" do
            
            expect do
                Rake::Task['salary_cap:populate'].invoke
                salary_cap_total.reload
                salary_cap_total_2.reload
            end.to change{ salary_cap_total.total }.from(0.0).to(player_cap_hit)
            .and change{ salary_cap_total_2.total }.from(0.0).to(player_cap_hit_2)

            expect(Team.all.count).to eq(2)
            expect(Player.all.count).to eq(2)
            expect(SalaryCapTotal.all.count).to eq(2)
        end
    end

    context "Multiple players" do 
        let!(:team) { Team.create(name: "Calgary Flames", code: "CGY")}
        let!(:player) { Player.create(name: "Dustin Wolf", team: team, position: "G") }
        let!(:player_2) { Player.create(name: "Blake Coleman", team: team, position: "C") }
        let!(:player_3) { Player.create(name: "Kevin Bahl", team: team, position: "D") }
        let!(:player_cap_hit) {  9000000.0 }
        let!(:blake_coleman_cap_hit) { 43000000.0 }
        let!(:kevin_bahl_cap_hit) {10000000.0 }
        let!(:contract_detail) { create_contract_with_cap_hit(player_cap_hit, player, "2024-25") }
        let!(:contract_detail_2) {create_contract_with_cap_hit(blake_coleman_cap_hit, player_2, "2024-25")}
        let!(:contract_detail_3) {create_contract_with_cap_hit(kevin_bahl_cap_hit, player_3, "2024-25")}
        let!(:salary_cap_total) {SalaryCapTotal.create(team: team, year: 2024, total: 0.0)}
        let!(:expected_cap_hit) {62000000.0}

        it "the total should equal the cap hit sum" do
            Rake::Task['salary_cap:populate'].invoke
            
            expect(SalaryCapTotal.all.count).to eq(1)
            expect(Player.all.count).to eq(3)
            expect(team.players.length).to eq(3)
           
            expect(SalaryCapTotal.find_by(team: team).total).to eq(expected_cap_hit)
        end

        context "A player is bought out" do
            let!(:buyout_player) { Player.create(name: "Kevin Smith", position: "D") }
            let!(:buyout_cap_hit) { 2000000.0 }
            let!(:contract) { Contract.create(player: buyout_player)}
            let!(:buyout_cap_hit_obj) { Buyout.create(team: team, contract: contract, season: format_year_to_season(2024),
                             cap_hit: buyout_cap_hit)}
            let!(:expected_cap_hit) {64000000.0}

            it "the total should include the buyout" do
                Rake::Task['salary_cap:populate'].invoke
                expect(SalaryCapTotal.find_by(team: team).total).to eq(expected_cap_hit)
            end
        end

        context "non roster players on the roster" do
            let!(:non_roster_player) { Player.create(name: "Parker Bell", team: team, position: "LW", status: Player::NON_ROSTER) }
            let!(:non_roster_cap_hit) { CapHit.create(team_id: team.id, player_id: non_roster_player.id, year: 2024, cap_value: 9000000.0 )}

            it "should not include the non roster salary in the cap hit sum" do
                Rake::Task['salary_cap:populate'].invoke

                expect(SalaryCapTotal.find_by(team: team).total).to eq(expected_cap_hit)
            end
        end

        context "multiple years" do
            let!(:contract_detail_4) { create_contract_with_cap_hit(player_cap_hit, player, "2025-26") }
            let!(:contract_detail_5) { create_contract_with_cap_hit(blake_coleman_cap_hit, player_2, "2025-26") }
            let!(:expected_cap_hit_2025) {52000000.0}
            let!(:salary_cap_total_2) {SalaryCapTotal.create(team: team, year: 2025, total: 0.0)}

            it "should sum the total for all years of data" do 
                Rake::Task['salary_cap:populate'].invoke

                expect(SalaryCapTotal.all.count).to eq(2)
                expect(team.salary_cap_totals.find_by(year: 2025)).not_to be_nil
                expect(Player.all.count).to eq(3)
                expect(SalaryCapTotal.find_by(team: team, year: 2025).total).to eq(expected_cap_hit_2025)
                expect(SalaryCapTotal.find_by(team: team, year: 2024).total).to eq(expected_cap_hit)
                
            end 
        end
    end
    
    def create_contract_with_cap_hit(cap_hit, player, season)
        contract =Contract.create(player_id: player.id)
         ContractDetail.create( season: season, contract:contract, cap_hit: cap_hit)
    end
end
