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
            player = Player.find_or_create_by(name: player_name)

            next if player.nil?
            status == 'NHL' ?   player.update( status: Player::ROSTER) : player.update(status: Player::NON_ROSTER)
 
            player.save!
        end
        puts 'Player statuses have been updated successfully.'
    end
end
