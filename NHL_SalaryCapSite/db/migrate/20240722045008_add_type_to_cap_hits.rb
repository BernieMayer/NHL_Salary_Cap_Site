class AddTypeToCapHits < ActiveRecord::Migration[6.0]
  def change
    add_column :cap_hits, :type, :string, default: "Roster"
  end
end

