class RenameTypeToCapTypeInCapHits < ActiveRecord::Migration[7.1]
  def change
    rename_column :cap_hits, :type, :cap_type
  end
end
