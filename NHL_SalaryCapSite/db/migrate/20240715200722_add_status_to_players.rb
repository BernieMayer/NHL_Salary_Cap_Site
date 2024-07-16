class AddStatusToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :status, :string, default: "Roster", null: false
  end
end
