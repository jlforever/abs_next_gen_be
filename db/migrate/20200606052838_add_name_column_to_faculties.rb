class AddNameColumnToFaculties < ActiveRecord::Migration[5.2]
  def change
    add_column :faculties, :name, :text, null: false, index: true
  end
end
