class AddGmAndCoachToTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :gm, :string
    add_column :teams, :coach, :string
  end
end
