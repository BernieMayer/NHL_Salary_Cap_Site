class AddCodeToTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :code, :string, limit: 3
  end
end
