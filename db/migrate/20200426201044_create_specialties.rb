class CreateSpecialties < ActiveRecord::Migration[5.2]
  def change
    create_table :specialties do |t|
      t.text :subject, null: false, index: true
      t.text :category, null: false
      t.text :focus_areas, null: false
      t.text :description

      t.timestamps null: false
    end
  end
end
