# lib/tasks/import_players.rake
require 'csv'

namespace :nhl do
  desc 'Import NHL players from CSV'
  task import_players: :environment do
    file_path = Rails.root.join('lib', 'assets', 'nhl_players.csv')

    # Ensure the file exists
    unless File.exist?(file_path)
      puts "File not found: #{file_path}"
      next
    end

    # Read and parse the CSV file
    CSV.foreach(file_path, headers: true) do |row|
      # Extract player attributes from the CSV row
      raw_player_name = row['PLAYER']
      player_name = raw_player_name.gsub(/^\d+\.\s*/, '') # Remove leading numbers and spaces
      team_code = row['TEAM']
      age = row['AGE'].to_i
      pos = row['POS']
      handed = row['HANDED']
      gp = row['GP'].to_i
      g = row['G'].to_i
      a = row['A'].to_i
      p = row['P'].to_i
      p_gp = row['P/GP'].to_f
      plus_minus = row['+/-'].to_i
      sh = row['Sh'].to_i
      sh_percent = row['Sh%'].to_f
      toi = row['TOI']
      w = row['W'].to_i
      l = row['L'].to_i
      so = row['SO'].to_i
      gaa = row['GAA'].to_f
      sv_percent = row['Sv%'].to_f
      clause = row['CLAUSE']
      expiry = row['EXPIRY']
      cap_hit = row['CAP HIT'].gsub(/[^\d\.]/, '').to_f
      salary = row['SALARY'].gsub(/[^\d\.]/, '').to_f

      # Find or create the team by code
      team = Team.find_or_create_by(code: team_code)

      # Find or create the player and update attributes
      player = Player.find_or_create_by(name: player_name)
      player.update(
        team: team,
        position: pos
      )
      player.save!
      puts "Imported player: #{player_name}"
    end

    puts 'Finished importing NHL players'
  end
end
