class RenameColumnsForKlasses < ActiveRecord::Migration[5.2]
  def change
    rename_column :klasses, :total_cost, :per_session_student_cost
    rename_column :klasses, :faculty_cut, :per_session_faulty_cut
  end
end
