class AddRegEffectiveFromAndEffectiveUntilToKlasses < ActiveRecord::Migration[5.2]
  def change
    add_column :klasses, :reg_effective_from, :datetime
    add_column :klasses, :reg_effective_until, :datetime

    add_index :klasses, :reg_effective_from
    add_index :klasses, :reg_effective_until
  end
end
