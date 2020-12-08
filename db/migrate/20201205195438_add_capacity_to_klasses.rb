class AddCapacityToKlasses < ActiveRecord::Migration[5.2]
  def change
    add_column :klasses, :capacity, :integer, null: false, default: 20
  end
end
