class CreateDraftPicks < ActiveRecord::Migration[7.1]
  def change
    create_table :draft_picks do |t|
      t.integer :year
      t.integer :round
      t.references :original_team, null: false, foreign_key: { to_table: :teams }
      t.references :current_team, null: false, foreign_key: { to_table: :teams }
      t.boolean :isTradedAway
      t.date :tradedDate
      t.text :conditions

      t.timestamps
    end
  end
end
