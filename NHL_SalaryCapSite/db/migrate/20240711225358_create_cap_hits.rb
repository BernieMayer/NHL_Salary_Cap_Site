
class CreateCapHits < ActiveRecord::Migration[6.0]
  def change
    create_table :cap_hits do |t|
      t.decimal :cap_value, precision: 12, scale: 2
      t.references :team, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.integer :year

      t.timestamps
    end
  end
end
