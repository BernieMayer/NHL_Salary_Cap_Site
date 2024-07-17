# lib/tasks/roster_approximator.rake

namespace :approximate do
    desc "Designate players as 'non roster' if they have a 2024 cap hit of less than 950K and 'roster' if they have a 2024 cap hit of more than 950K"
    task roster_approximator: :environment do
      threshold = 950_000
  
      Player.find_each do |player|
       
        cap_hit_2024 = player.cap_hits.find_by(year:2024)
        
        next if cap_hit_2024.nil?

        cap_hit_value_2024 = cap_hit_2024.cap_value

        if cap_hit_value_2024 < threshold
          player.update(status: 'Non-Roster')
          puts "Updated #{player.name} to Non-Roster"
        else
          player.update(status: 'Roster')
          puts "Updated #{player.name} to Roster"
        end
      end
  
      puts "Player statuses have been updated based on 2024 cap hit."
    end
  end
  