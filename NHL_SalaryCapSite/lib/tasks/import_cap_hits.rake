namespace :nhl do
    desc "Import cap hits from CSV"
    task import_cap_hits: :environment do
      require 'csv'
  
      csv_file_path = Rails.root.join('lib', 'assets', 'nhl_player_cap_hits.csv')
  
      CSV.foreach(csv_file_path, headers: true) do |row|
        # Convert name format from "<Last Name>, <First Name>" to "<First Name> <Last Name>"
        player_name = row['player_name'].strip
        if player_name == "Totals"
          next
        else
          last_name, first_name = player_name.split(', ').map(&:strip)
          player_name = "#{first_name} #{last_name}"
        end
  
        team_name = row['team'].strip
  
        # Extract cap hits for each year
        cap_hits = {
          "2024-25" => row['2024-25'].to_f,
          "2025-26" => row['2025-26'].to_f,
          "2026-27" => row['2026-27'].to_f,
          "2027-28" => row['2027-28'].to_f
        }
  
        # Find the player and team
        player = Player.find_by(name: player_name)
        team = Team.find_by(name: team_name)
  
        if player && team
          cap_hits.each do |year, cap_hit|
            # Check if a cap hit already exists for the player and year
            existing_cap_hit = CapHit.find_by(player: player, year: year)
  
            if existing_cap_hit.nil? && cap_hit > 0
              # Create new cap hit if it doesn't exist
              CapHit.create(player: player, team: team, year: year, cap_value: cap_hit)
              puts "Added cap hit for #{player_name} - #{year}: #{cap_hit}"
            else
              puts "Skipping #{player_name} - #{year}: Cap hit already exists or is zero."
            end
          end
        else
          puts "Skipping #{player_name} - #{team_name}: Player or team not found."
        end
      end
    end
  end
  