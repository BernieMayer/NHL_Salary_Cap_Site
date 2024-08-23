class AddDetailsToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :acquired, :string
    add_column :players, :draftDetails, :string
    add_column :players, :born, :date
    add_column :players, :termsDetails, :text
  end
end
