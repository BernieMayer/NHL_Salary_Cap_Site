namespace :salary_cap do
    include SeasonHelper
    desc 'Populate salary cap totals'
    task populate: :environment do

        def sum_roster_player_cap_hits(team, year)
            cap_hits_total = 0.0
            team.players.roster.each do |player|
                cap_hit = player.cap_hit_for_team_in_season(team, format_year_to_season(year))
                
                next if cap_hit.nil?
                cap_hits_total += cap_hit

            end
            cap_hits_total 
        end

        def sum_buyout_player_cap_hits(team, year)
            cap_hits_total = 0.0
            buyout_cap_hits = CapHit.buyout.where(year: year).where(team: team)
            return 0 if buyout_cap_hits.nil?
            buyout_cap_hits.each do |cap_hit|
                next if cap_hit.nil?
                puts "Adding buyout cap hit of #{cap_hit.cap_value}"
                cap_hits_total += cap_hit.cap_value
            end
            cap_hits_total 
        end

        Team.all.each do |team|
            (2024...2030).each do |year|
                salary_cap_total = team.salary_cap_totals.find_by(year:year)

                next if salary_cap_total.nil?

                cap_hits_total = 0.0
                cap_hits_total += sum_roster_player_cap_hits(team, year)
                cap_hits_total += sum_buyout_player_cap_hits(team, year)
                salary_cap_total.total = cap_hits_total
                salary_cap_total.save!
            end
        end
  
      puts 'Salary cap totals populated successfully.'
    end
  end
  