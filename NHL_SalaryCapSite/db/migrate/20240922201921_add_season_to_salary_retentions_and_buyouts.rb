class AddSeasonToSalaryRetentionsAndBuyouts < ActiveRecord::Migration[7.1]
  def change
    add_column :salary_retentions, :season, :string
    add_column :buyouts, :season, :string
  end
end
