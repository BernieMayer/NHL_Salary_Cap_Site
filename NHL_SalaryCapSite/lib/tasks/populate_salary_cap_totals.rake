namespace :salary_cap do
    desc 'Populate salary cap totals'
    task populate: :environment do

        Team.all.each do |team|
            (2024...2030).each do |year|
                salary_cap_total = team.salary_cap_totals.find_by(year:year)

                next if salary_cap_total.nil?

                cap_hits_total = 0.0
                team.players.roster.each do |player|
                    cap_hit =  player.cap_hits.find_by(year: year)
                    next if cap_hit.nil?
                    
                    cap_hits_total += cap_hit.cap_value
                end
                salary_cap_total.total = cap_hits_total
                salary_cap_total.save!
            end
        end
  
      puts 'Salary cap totals populated successfully.'
    end
  end
  