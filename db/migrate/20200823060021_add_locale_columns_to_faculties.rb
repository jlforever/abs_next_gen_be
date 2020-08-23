class AddLocaleColumnsToFaculties < ActiveRecord::Migration[5.2]
  def change
    add_column :faculties, :address1, :text
    add_column :faculties, :address2, :text
    add_column :faculties, :city, :text
    add_column :faculties, :state, :text
    add_column :faculties, :zip, :text
  end
end
