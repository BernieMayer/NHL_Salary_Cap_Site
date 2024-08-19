class CreateContracts < ActiveRecord::Migration[7.1]
  def change
    create_table :contracts do |t|
      t.references :player, null: false, foreign_key: true
      t.string :expiry_status

      t.timestamps
    end
  end
end
