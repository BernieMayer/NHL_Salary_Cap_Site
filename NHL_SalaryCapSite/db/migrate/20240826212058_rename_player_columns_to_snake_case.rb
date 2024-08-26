class RenamePlayerColumnsToSnakeCase < ActiveRecord::Migration[7.1]
  def change
    rename_column :players, :draftDetails, :draft_details
    rename_column :players, :termsDetails, :terms_details
    rename_column :players, :careerGamesPlayed, :career_games_played
    rename_column :players, :careerSeasonsPlayed, :career_seasons_played
  end
end
