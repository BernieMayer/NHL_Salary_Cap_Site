namespace :salary_cap do
    desc 'Populate salary cap totals'
    task populate: :environment do

        Team.all.each do |team|
            puts "Team is #{team.name}"
            (2024...2030).each do |year|
                salary_cap_total = SalaryCapTotal.find_by(team: team, year: year)

                next if salary_cap_total.nil?

                cap_hits_total = 0.0
                team.players.each do |player|
                    puts "Adding cap hit"
                    cap_hits_total += CapHit.find_by(team: team, year:year, player: player).cap_value
                end
                salary_cap_total.total = cap_hits_total
                salary_cap_total.save!
            end
        end
  
      puts 'Salary cap totals populated successfully.'
    end
  end
  