class CreateBuyouts < ActiveRecord::Migration[7.1]
  def change
    create_table :buyouts do |t|
      t.references :contract, null: false, foreign_key: true
      t.string :team_name
      t.decimal :cost
      t.decimal :earning
      t.decimal :savings
      t.decimal :cap_hit

      t.timestamps
    end
  end
end
