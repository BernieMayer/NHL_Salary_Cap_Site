class AddIndexToTeamsName < ActiveRecord::Migration[7.1]
  def change
    add_index :teams, :name, unique: true
  end
end
