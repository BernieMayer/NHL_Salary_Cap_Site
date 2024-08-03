class ChangeTeamColumnsToString < ActiveRecord::Migration[7.1]
  def change
    change_column :teams, :name, :text
    change_column :teams, :code, :text
  end
end
