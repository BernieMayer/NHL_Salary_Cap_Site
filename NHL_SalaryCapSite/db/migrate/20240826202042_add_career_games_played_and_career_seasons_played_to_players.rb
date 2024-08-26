class AddCareerGamesPlayedAndCareerSeasonsPlayedToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :careerGamesPlayed, :integer
    add_column :players, :careerSeasonsPlayed, :integer
  end
end
