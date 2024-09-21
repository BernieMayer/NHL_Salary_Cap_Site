require 'rails_helper'
require 'rake'

RSpec.describe 'import:contracts', type: :task do
  let(:task_name) { 'import:contracts' }
  let(:json_file_path) { Rails.root.join('spec', 'fixtures', 'files', 'calgary_flames.json') }

  before do
    # Explicitly load the rake task file
    Rake.application.rake_require('lib/tasks/import_contracts', [Rails.root.to_s])
    Rake::Task.define_task(:environment)
  end

  it 'imports contract data from a JSON file' do
    # Stub file path and existence check to return true
    allow(File).to receive(:exist?).with(json_file_path.to_s).and_return(true)

    # Stub file reading
    json_data = File.read(json_file_path)
    allow(File).to receive(:read).with(json_file_path.to_s).and_return(json_data)

    # Stub JSON parsing
    parsed_json = JSON.parse(json_data)
    allow(JSON).to receive(:parse).with(json_data).and_return(parsed_json)

    # Create a team for testing
    team = Team.create!(name: "Calgary Flames", code: "CGY", gm: nil, coach: nil)

    # Run the rake task and capture output
    expect { Rake::Task[task_name].invoke(json_file_path.to_s) }.to output(/Data import complete!/).to_stdout

    # Reload team data to check for updates
    team.reload
    expect(team.gm).to eq('Brad Treliving')
    expect(team.coach).to eq('Darryl Sutter')

    # Check players have been imported
    player = Player.find_by(name: 'Johnny Gaudreau')
    expect(player).not_to be_nil
    expect(player.position).to eq('LW')
    expect(player.career_games_played).to eq(500)

    defense_player = Player.find_by(name: 'Rasmus Andersson')
    expect(defense_player).not_to be_nil
    expect(defense_player.position).to eq('D')

    goalie = Player.find_by(name: 'Jacob Markstrom')
    expect(goalie).not_to be_nil
    expect(goalie.position).to eq('G')

    # Check contracts have been created
    contract = Contract.find_by(player_id: player.id)
    expect(contract).not_to be_nil
    expect(contract.expiry_status).to eq('UFA')

    contract_detail = ContractDetail.find_by(contract_id: contract.id, season: '2023-2024')
    expect(contract_detail).not_to be_nil
    expect(contract_detail.cap_hit).to eq(6750000.to_d)
  end
end
