class RenameClassToKlass < ActiveRecord::Migration[5.2]
  def change
    rename_table :classes, :klasses
  end
end
