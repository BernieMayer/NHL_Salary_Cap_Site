require 'rails_helper'
require 'rake'

describe 'salary_cap:populate' do
    before(:all) do
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
end
