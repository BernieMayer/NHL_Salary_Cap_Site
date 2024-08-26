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

    def convert_currency(value)
      return 0 if value.nil?
      value.delete('$,').to_d
    end

       # Method to process players and their contracts
       def process_players(players)
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
            acquired: acquired,
            terms_details: terms_details,
            draft_details: acquisition_details,
            born: born,
            career_games_played: career_games_played,
            career_seasons_played: career_seasons_played
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
              end
            else
              puts "Error: Failed to create contract for player - #{player_record.name}"
            end
          end
        end
      end
  
      # Process forwards, defense, and goalies
      process_players(data['pageProps']['data']['roster']['forwards'])
      process_players(data['pageProps']['data']['roster']['defense'])
      process_players(data['pageProps']['data']['roster']['goalies'])

      data['pageProps']["draftPicks"].each do |draft_pick|
        original_team = Team.find_by(name: data['pageProps']["teamName"])
        team = Team.find_by(name: draft_pick["team"])
        next unless team
  
        DraftPick.create!(
          year: draft_pick["year"],
          round: draft_pick["round"],
          original_team: original_team, 
          current_team: team, 
          conditions: draft_pick["conditions"],
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
