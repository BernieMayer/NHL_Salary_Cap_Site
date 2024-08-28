class CreateSalaryRetentions < ActiveRecord::Migration[7.1]
  def change
    create_table :salary_retentions do |t|
      t.references :team, null: false, foreign_key: true
      t.references :contract, null: false, foreign_key: true
      t.decimal :retained_cap_hit, precision: 12, scale: 2, null: false
      t.decimal :retention_percentage, precision: 5, scale: 2, null: false

      t.timestamps
    end
  end
end
