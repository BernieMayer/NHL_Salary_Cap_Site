class AddTeamToBuyouts < ActiveRecord::Migration[7.1]
  def change
    add_reference :buyouts, :team, null: false, foreign_key: true
  end
end
