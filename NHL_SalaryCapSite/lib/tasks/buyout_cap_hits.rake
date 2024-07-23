# lib/tasks/buyout_cap_hits.rake

namespace :nhl do
  desc "Manage buyout cap hits for a player"
  task manage_buyout_cap_hits: :environment do
    require 'io/console'

    puts "Enter the player's name (First Last):"
    player_name = STDIN.gets.chomp

    # Find the player by name
    player = Player.find_by(name: player_name)

    unless player
      puts "Player not found"
      next
    end

    current_team = player.team ? player.team.name : "No current team"
    puts "#{player_name} is currently playing for #{current_team}."

    # Ask if the user wants to remove current cap hits for the player
    puts "Do you want to remove all current cap hits for #{player_name} on their current team? (yes/no)"
    remove_cap_hits_response = STDIN.gets.chomp.downcase

    if remove_cap_hits_response == 'yes'
      player.cap_hits.destroy_all
      puts "Removed all current cap hits for #{player_name}."
    end

    # Choose the team for buyout cap hits
    puts "Do you want to assign the buyout cap hits to a different team? (yes/no)"
    different_team_response = STDIN.gets.chomp.downcase

    team = player.team
    if different_team_response == 'yes'
      puts "Enter the name of the team for the buyout cap hits:"
      team_name = STDIN.gets.chomp
      team = Team.find_by(name: team_name)

      unless team
        puts "Team not found"
        next
      end
    end

    # Adding new buyout cap hits
    current_year = 2024
    puts "Adding buyout cap hits for #{player_name}. You can stop at any time by typing 'stop'."
    loop do
      puts "Enter the buyout cap hit for the year #{current_year}-#{current_year + 1} (or type 'stop' to finish):"
      cap_hit_input = STDIN.gets.chomp

      break if cap_hit_input.downcase == 'stop'

      begin
        cap_hit_value = Float(cap_hit_input.gsub(/[^\d.]/, ''))
      rescue ArgumentError
        puts "Invalid input. Please enter a valid number or 'stop'."
        next
      end

      # Create the buyout cap hit
      CapHit.create!(player: player, team: team, year: "#{current_year}-#{current_year + 1}", cap_value: cap_hit_value, cap_type: 'Buyout')
      puts "Added buyout cap hit for #{player_name} - #{current_year}-#{current_year + 1}: $#{cap_hit_value}"

      current_year += 1
      break if current_year > 2030
    end

    puts "Buyout cap hits management for #{player_name} completed."
  end
end
