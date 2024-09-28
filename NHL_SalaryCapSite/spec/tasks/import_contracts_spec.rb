require 'rails_helper'
require 'rake'

RSpec.describe 'import:contracts', type: :task do
  let(:task_name) { 'import:contracts' }
  let!(:json_file_path) { fixture_file_upload Rails.root.join('spec', 'fixtures', 'files', 'anaheim_ducks.json') }

  before do
    # Explicitly load the rake task file
    Rake.application.rake_require('lib/tasks/import_contracts', [Rails.root.to_s])
    Rake::Task.define_task(:environment)
    Rake::Task['import:contracts'].reenable
  end

  context "boston bruins" do
    let!(:json_file_path) { fixture_file_upload Rails.root.join('spec', 'fixtures', 'files', 'boston_bruins.json') }

    it 'imports contract data from a JSON file' do
      # Create a team for testing
      team = Team.create!(name: "Boston Bruins", code: "BOS", gm: nil, coach: nil)

      # Run the rake task and capture output
      Rake::Task[task_name].invoke(json_file_path) 

      # Reload team data to check for updates
      team.reload
      expect(team.gm).to eq('Don Sweeney')
      expect(team.coach).to eq('Jim Montgomery')

      expect(DraftPick.all.length).to eq(21)
      expect(Player.all.length).to eq(46)

      # Check players have been imported
      player = Player.find_by(name: 'Michael DiPietro')
      expect(player).not_to be_nil
      # expect(player.position).to eq('RW, LW')
      # expect(player.career_games_played).to eq(0)
      expect(player.contracts.length).to eq(2)



    end

  end

  context" default" do

    it 'imports contract data from a JSON file' do
      # Create a team for testing
      team = Team.create!(name: "Anaheim Ducks", code: "ANA", gm: nil, coach: nil)

      # Run the rake task and capture output
      Rake::Task[task_name].invoke(json_file_path) 

      # Reload team data to check for updates
      team.reload
      expect(team.gm).to eq('Pat Verbeek')
      expect(team.coach).to eq('Greg Cronin')

      expect(DraftPick.all.length).to eq(21)
      expect(Player.all.length).to eq(48)

      # Check players have been imported
      player = Player.find_by(name: 'Troy Terry')
      expect(player).not_to be_nil
      expect(player.position).to eq('RW, LW')
      expect(player.career_games_played).to eq(0)
      expect(player.contracts.length).to eq(1)

      player2 = Player.find_by(name: "Mason McTavish")
      expect(player2.contracts.length).to eq(1)

      # defense_player = Player.find_by(name: 'Rasmus Andersson')
      # expect(defense_player).not_to be_nil
      # expect(defense_player.position).to eq('RD')

      # goalie = Player.find_by(name: 'Dustin Wolf')
      # expect(goalie).not_to be_nil
      # expect(goalie.position).to eq('G')

      # expect(player.contracts.length).to eq(1)
      # expect(goalie.contracts.length).to eq(1)
      # Check contracts have been created
      # contract = Contract.find_by(player_id: goalie.id)
      # expect(contract).not_to be_nil
      # expect(contract.expiry_status).to eq('UFA')

      # contract_detail = ContractDetail.find_by(contract_id: contract.id, season: '2023-2024')
      # expect(contract_detail).not_to be_nil
      # expect(contract_detail.cap_hit).to eq(6750000.to_d)
    end
  end
end
