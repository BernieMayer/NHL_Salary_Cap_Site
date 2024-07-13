class CreateSalaryCapTotals < ActiveRecord::Migration[7.1]
  def change
    create_table :salary_cap_totals do |t|
      t.references :team, null: false, foreign_key: true
      t.decimal :total
      t.integer :year

      t.timestamps
    end
  end
end
