# lib/tasks/import_contracts.rake
namespace :import do
  desc "Import contract data from a JSON file"
  task :contracts, [:file_path] => :environment do |t, args|
    require 'json'
    require 'active_record'

    # Path to your JSON file
    file_path = args[:file_path] || Rails.root.join('lib', 'assets', 'nhl_teams_json', 'calgary_flames.json')
  

    unless File.exist?(file_path)
      puts "File not found: #{file_path}"
      next
    end

    file = File.read(file_path)
    data = JSON.parse(file)

    team_data = data['pageProps']['teamMetadata']
    team_name = data['pageProps']['teamName']
    gm = team_data['gm']
    coach = team_data['coach']

    # Find or initialize the team
    team = Team.find_or_initialize_by(name: team_name)
    
    # Update the gm and coach attributes
    team.gm = gm
    team.coach = coach

    # Save the team with updated attributes
    if team.save
      puts "Updated team: #{team.name} with GM: #{team.gm} and Coach: #{team.coach}"
    else
      puts "Failed to update team: #{team.errors.full_messages.join(', ')}"
    end

    # Helper method to transform name format
    def format_name(name)
      last_name, first_name = name.split(', ').map(&:strip)
      "#{first_name} #{last_name}"
    end

    # Helper method to find a player by name
    def find_player(name)
      formatted_name = format_name(name)
      player = Player.find_by(name: formatted_name)
      unless player
        puts "Error: Player not found - #{formatted_name}"
      end
      player
    end

    def convert_status(status)
      if status.nil?
        return status
      end

      if status == "NHL"
        Player::ROSTER
      elsif status.include?("IR")
        Player::IR
      else 
        status
      end
    end

    def convert_currency(value)
      return 0 if value.nil?
      value.delete('$,').to_d
    end

       # Method to process players and their contracts
      def process_players(players, team)
        return if players.nil?
        players.each do |player|
          player_record = find_player(player['name'])
          
          next unless player_record  # Skip if player not found
          slug = player['slug']
          pos = player['pos']
          status = player['status']
          acquired = player['acquired']
          terms_details = player['termsDetails']
          acquisition_details = player['acquisitionDetails']
          born = player['born']
          career_games_played = player['careerGamesPlayed']
          career_seasons_played = player['careerSeasonsPlayed']

          player_record.update(
            team: team,
            position: pos,
            acquired: acquired,
            terms_details: terms_details,
            draft_details: acquisition_details,
            born: born,
            career_games_played: career_games_played,
            career_seasons_played: career_seasons_played,
            status: convert_status(status) 
          )
  
          player['contracts'].each do |contract|
            # Skip if contract details are empty
            next if contract['details'].nil? || contract['details'].empty?
  
            expiry_status = contract['expiryStatus']
  
            # Create the contract record
            created_contract = Contract.create(
              player_id: player_record.id,
              expiry_status: expiry_status
            )
  
            if created_contract.persisted?
              # Create contract details records
              contract['details'].each do |detail|
                ContractDetail.create!(
                  contract: created_contract,
                  season: detail['season'],
                  clause: detail['clause'],
                  cap_hit: convert_currency(detail['capHit']),
                  aav: convert_currency(detail['aav']),
                  performance_bonuses: convert_currency(detail['performanceBonuses']),
                  signing_bonuses: convert_currency(detail['signingBonuses']),
                  base_salary: convert_currency(detail['baseSalary']),
                  total_salary: convert_currency(detail['totalSalary']),
                  minors_salary: convert_currency(detail['minorsSalary'])
                )

                if detail['retention']
                  detail['retention'].each do |team_name, retention_data|
                    team = Team.find_by(name: team_name)
      
                    # Handle case where team might not exist
                    unless team
                      puts "Team not found: #{team_name}. Skipping retention entry."
                      next
                    end
      
                    # Create the salary retention record
                    SalaryRetention.create!(
                      team: team,
                      contract: created_contract,
                      retained_cap_hit: retention_data['capHit'].delete('$,').to_f,
                      retention_percentage: retention_data['retention'].delete('%').to_f
                    )
                  end
                end
                
                if detail["buyout"]
                  buyout_team = Team.find_by(name: detail["buyout"]["teamName"])
      
                  # Handle case where team might not exist
                  unless buyout_team
                    puts "Team not found: #{detail["buyout"]["teamName"]}. Skipping buyout entry."
                    next
                  end

                  Buyout.create!(
                    contract_id: created_contract.id,
                    team_id: buyout_team.id,
                    cost: convert_currency(detail["buyout"]["cost"]),
                    earning: convert_currency(detail["buyout"]["earning"]),
                    savings: convert_currency(detail["buyout"]["savings"]),
                    cap_hit: convert_currency(detail["buyout"]["capHit"])
                  )
                end

              end
            else
              puts "Error: Failed to create contract for player - #{player_record.name}"
            end
          end
        end
      end
  
      # Process forwards, defense, and goalies
      process_players(data['pageProps']['data']['roster']['forwards'], team)
      process_players(data['pageProps']['data']['roster']['defense'], team)
      process_players(data['pageProps']['data']['roster']['goalies'], team)
      process_players(data['pageProps']['data']['non-roster']['forwards'], team)
      process_players(data['pageProps']['data']['non-roster']['defense'], team)
      process_players(data['pageProps']['data']['non-roster']['goalies'], team)
      process_players(data['pageProps']['data']['dead cap']['buyout history'], team)

      data['pageProps']["draftPicks"].each do |draft_pick|
        original_team = Team.find_by(name: data['pageProps']["teamName"])
        team = Team.find_by(name: draft_pick["team"])
        next unless team
  
        DraftPick.create!(
          year: draft_pick["year"],
          round: draft_pick["round"],
          original_team: original_team, 
          current_team: team, 
          conditions: draft_pick["conditions"].nil? ? "" : draft_pick["conditions"].first,
          isTradedAway: draft_pick["isTradedAway"],
          tradedDate: draft_pick["tradedDate"]
        )
      end

      if data['pageProps']['draftPicks'].nil?
        puts "No draft picks found in the JSON data."
      end

    puts 'Data import complete!'
  end
end
