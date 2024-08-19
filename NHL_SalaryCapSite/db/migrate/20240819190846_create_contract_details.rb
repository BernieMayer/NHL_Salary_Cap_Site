class CreateContractDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :contract_details do |t|
      t.references :contract, null: false, foreign_key: true
      t.string :season
      t.string :clause
      t.decimal :cap_hit, precision: 15, scale: 2
      t.decimal :aav, precision: 15, scale: 2
      t.decimal :performance_bonuses, precision: 15, scale: 2
      t.decimal :signing_bonuses, precision: 15, scale: 2
      t.decimal :base_salary, precision: 15, scale: 2
      t.decimal :total_salary, precision: 15, scale: 2
      t.decimal :minors_salary, precision: 15, scale: 2

      t.timestamps
    end
  end
end
