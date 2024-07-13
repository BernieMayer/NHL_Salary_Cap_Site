require 'rails_helper'
require 'rake'

describe 'salary_cap:populate' do
    before(:all) do
        Rake.application.load_rakefile
        Rake::Task['salary_cap:populate'].reenable
      end

    context "One cap hit" do
        let!(:team) { Team.create(name: "Calgary Flames")}
        let!(:player) { Player.create(name: "Dustin Wolf")}
        let!(:player_cap_hit) {  9000000.0}
        let!(:cap_hit) {CapHit.create(team_id: team.id, player: player, year: 2024,cap_value:player_cap_hit )}

        it "the total should equal the cap hit" do
            expect(SalaryCapTotal.find_by(team: team).total).to eq(player_cap_hit)
        end
    end
end
