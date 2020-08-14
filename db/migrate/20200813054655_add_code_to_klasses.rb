class AddCodeToKlasses < ActiveRecord::Migration[5.2]
  def change
    add_column :klasses, :code, :text

    add_index :klasses, :code
  end
end
