class RenameTypoKlassColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :klasses, :effective_unitl, :effective_until
  end
end
