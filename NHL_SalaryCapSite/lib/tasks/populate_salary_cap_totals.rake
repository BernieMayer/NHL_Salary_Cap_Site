namespace :salary_cap do
    desc 'Populate salary cap totals'
    task populate: :environment do
        include SeasonHelper

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
            buyouts = Buyout.get_buyouts_for_team_season(format_year_to_season(year), team)
            return 0 if buyouts.nil?
            buyouts.all.each do |buyout|
                next if buyout.cap_hit.nil?
                cap_hits_total += buyout.cap_hit
            end
            cap_hits_total 
        end

        def sum_retention_player_cap_hits(team, year)
            cap_hits_total = 0.0
            retentions = SalaryRetention.retention_for_season_and_team(format_year_to_season(year), team)
            return 0 if retentions.nil?
            retentions.all.each do |retention|
                cap_hits_total += retention.retained_cap_hit
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
                cap_hits_total += sum_retention_player_cap_hits(team, year)
                salary_cap_total.total = cap_hits_total
                salary_cap_total.save!
            end
        end
  
      puts 'Salary cap totals populated successfully.'
    end
  end
  