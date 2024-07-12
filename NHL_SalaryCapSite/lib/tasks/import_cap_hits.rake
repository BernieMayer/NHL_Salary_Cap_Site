# lib/tasks/import_cap_hits.rake
require 'csv'

namespace :nhl do
  desc "Import cap hits from CSV"
  task import_cap_hits: :environment do
    file_path = 'lib/assets/nhl_player_cap_hits.csv'

    unless File.exist?(file_path)
      puts "File not found: #{file_path}"
      exit
    end

    CSV.foreach(file_path, headers: true) do |row|
      player_name_csv = row['player_name'].strip
      team_name = row['team'].strip

      # Convert "<Last Name>, <First Name>" to "<First Name> <Last Name>"
      last_name, first_name = player_name_csv.split(',').map(&:strip)
      player_name = "#{first_name} #{last_name}"

      # Find or create the player and team
      player = Player.find_by(name: player_name)
      team = Team.find_by(name: team_name)

      unless player && team
        puts "Skipping #{player_name} - #{team_name}: Player or team not found"
        next
      end

      # Import cap hits for each year
      (2024..2027).each do |year|
        cap_value = row["#{year}-#{(year + 1).to_s[-2..-1]}"]
        next if cap_value.blank?

        CapHit.create!(
          player: player,
          team: team,
          year: year,
          cap_value: cap_value
        )
      end
    end

    puts "Cap hits import completed."
  end
end
