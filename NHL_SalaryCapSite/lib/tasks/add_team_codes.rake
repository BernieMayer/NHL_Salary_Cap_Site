# lib/tasks/add_team_codes.rake
namespace :nhl do
    desc 'Add codes to NHL teams'
    task add_team_codes: :environment do
      team_codes = {
        "Boston Bruins" => "BOS",
        "Buffalo Sabres" => "BUF",
        "Detroit Red Wings" => "DET",
        "Florida Panthers" => "FLA",
        "Montreal Canadiens" => "MTL",
        "Ottawa Senators" => "OTT",
        "Tampa Bay Lightning" => "TBL",
        "Toronto Maple Leafs" => "TOR",
        "Carolina Hurricanes" => "CAR",
        "Columbus Blue Jackets" => "CBJ",
        "New Jersey Devils" => "NJD",
        "New York Islanders" => "NYI",
        "New York Rangers" => "NYR",
        "Philadelphia Flyers" => "PHI",
        "Pittsburgh Penguins" => "PIT",
        "Washington Capitals" => "WSH",
        "Chicago Blackhawks" => "CHI",
        "Colorado Avalanche" => "COL",
        "Dallas Stars" => "DAL",
        "Minnesota Wild" => "MIN",
        "Nashville Predators" => "NSH",
        "St. Louis Blues" => "STL",
        "Winnipeg Jets" => "WPG",
        "Anaheim Ducks" => "ANA",
        "Utah Hockey Club" => "UTA",
        "Calgary Flames" => "CGY",
        "Edmonton Oilers" => "EDM",
        "Los Angeles Kings" => "LAK",
        "San Jose Sharks" => "SJS",
        "Seattle Kraken" => "SEA",
        "Vancouver Canucks" => "VAN",
        "Vegas Golden Knights" => "VGK"
      }
  
      team_codes.each do |team_name, code|
        team = Team.find_by(name: team_name)
        if team
          team.update(code: code)
          puts "Updated #{team_name} with code #{code}"
        else
          puts "Team not found: #{team_name}"
        end
      end
  
      puts 'Finished updating team codes'
    end
  end
  