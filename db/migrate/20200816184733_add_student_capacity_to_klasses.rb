class AddStudentCapacityToKlasses < ActiveRecord::Migration[5.2]
  def change
    add_column :klasses, :student_capacity, :integer, null: false, default: 100
  end
end
