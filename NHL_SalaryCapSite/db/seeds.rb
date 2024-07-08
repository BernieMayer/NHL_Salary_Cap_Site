# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Player.create(name: 'Blake Coleman', team: 'CGY', position: 'LW, RW')
Player.create(name: 'Jack Eichel', team: 'VGK', position: 'C')
# Add more players as needed


# db/seeds.rb

# Array of NHL team names
team_names = [
  "Anaheim Ducks", "Boston Bruins", "Buffalo Sabres", "Calgary Flames",
  "Carolina Hurricanes", "Chicago Blackhawks", "Colorado Avalanche", "Columbus Blue Jackets",
  "Dallas Stars", "Detroit Red Wings", "Edmonton Oilers", "Florida Panthers", "Los Angeles Kings",
  "Minnesota Wild", "Montreal Canadiens", "Nashville Predators", "New Jersey Devils",
  "New York Islanders", "New York Rangers", "Ottawa Senators", "Philadelphia Flyers",
  "Pittsburgh Penguins", "San Jose Sharks", "Seattle Kraken", "St. Louis Blues", "Tampa Bay Lightning",
  "Toronto Maple Leafs", "Vancouver Canucks", "Utah Hockey Club", "Vegas Golden Knights", "Washington Capitals",
  "Winnipeg Jets"
]

# Create Team records
team_names.each do |name|
  Team.create(name: name)
end

