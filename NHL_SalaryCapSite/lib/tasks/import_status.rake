require 'csv'   

namespace :nhl do
    desc 'Import players status from CSV'
    task import_status: :environment do

        # Path to your CSV file
    csv_file_path =  Rails.root.join('lib', 'assets','nhl_players_v1_1.csv' )


    def format_team_name(team_name)
        team_name.split('_').map(&:capitalize).join(' ')
    end

    def cap_hit_to_float(cap_hit)
        cap_hit.delete('$,').to_f if cap_hit
    end
    # Read CSV file and update/create Player records
        CSV.foreach(csv_file_path, headers: true) do |row|
            team_name = format_team_name(row['Team'])
            raw_player_name = row['Player Name']
            years_remaining = row['Years Remaining']
            terms = row['Terms']
            pos = row['POS']
            status = row['Status']
            acquired = row['Acquired']
            age = row['Age']
            cap_percent = row['Cap%']
            cap_hits = [
                cap_hit_to_float(row['2024-25']),
                cap_hit_to_float(row['2025-26']),
                cap_hit_to_float(row['2026-27']),
                cap_hit_to_float(row['2027-28']),
                cap_hit_to_float(row['2028-29']),
                cap_hit_to_float(row['2029-30'])
            ]

            
            last_name, first_name = raw_player_name.split(', ').map(&:strip)
            player_name = "#{first_name} #{last_name}"
            team = Team.find_by(name: team_name)
            player = Player.find_by(name: player_name)

            next if player.nil?
            status == 'NHL' ?   player.update( status: Player::ROSTER) : player.update(status: Player::NON_ROSTER)
 
            if player && team
                cap_hits.each do |year, cap_hit|
                  # Check if a cap hit already exists for the player and year
                  existing_cap_hit = CapHit.find_by(player: player, year: year)
                  next if cap_hit.nil?

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
 
            player.save!
        end
        puts 'Player statuses have been updated successfully.'
    end
end
