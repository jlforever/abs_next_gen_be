class AddMoreIndicesForKlasses < ActiveRecord::Migration[5.2]
  def change
    add_index :klasses, [:effective_from, :effective_unitl], name: 'idx_klasses_on_effective_from_to_until'
    add_index :klasses, [:faculty_id, :specialty_id, :effective_from], unique: true, name: 'idx_klasses_on_uniq_faculty_specialty_start_time'
    add_index :klasses, :taught_via
  end
end
