class AddIndexToPlayersName < ActiveRecord::Migration[7.1]
  def change
    add_index :players, :name
  end
end
