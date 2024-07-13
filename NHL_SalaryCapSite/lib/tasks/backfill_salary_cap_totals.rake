namespace :salary_cap do
    desc "Backfill salary cap totals with 0 for each year and team from 2024 to 2030"
    task backfill_totals: :environment do
      years = (2024..2030).to_a
      teams = Team.all
  
      teams.each do |team|
        years.each do |year|
          SalaryCapTotal.find_or_create_by(team: team, year: year) do |salary_cap_total|
            salary_cap_total.total = 0
          end
        end
      end
  
      puts "Backfill completed for salary cap totals."
    end
  end
  