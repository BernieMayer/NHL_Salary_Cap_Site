class RenameTeamToTeamIdInPlayers < ActiveRecord::Migration[7.1]
  def change
    # Rename the column from 'team' to 'team_id'
    rename_column :players, :team, :team_id

    # Change the type of the column to integer
    change_column :players, :team_id, :integer

    # Add the foreign key constraint
    add_foreign_key :players, :teams, column: :team_id

    # Add an index for the new foreign key
    add_index :players, :team_id
  end
end
