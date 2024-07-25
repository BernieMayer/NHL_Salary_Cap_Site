# lib/tasks/import_free_agents.rake

namespace :nhl do
  desc "Import NHL free agents from CSV"
  task import_free_agents: :environment do
    require 'csv'

    csv_file_path = Rails.root.join('lib', 'assets', 'nhl_free_agents.csv')

    CSV.foreach(csv_file_path, headers: true) do |row|
      player_name = row['player'].strip
      team_name = row['team'].strip
      position = row['position'].strip
      age = row['age'].to_i
      contract_status = row['contract_status'].strip
      cap_hit = row['cap_hit'].to_f
      signing_year = row['signing_year'].to_i
      expiry_status = row['expiry_status'].strip

      # Find or create team
      team = Team.find_or_create_by(name: team_name)

      # Create or find player record
      player = Player.find_or_initialize_by(name: player_name)
      player.position = position
      

      player.save!

      puts "Imported free agent: #{player_name}, Team: #{team_name}, Position: #{position}"
    end

    puts "Import completed."
  end
end
