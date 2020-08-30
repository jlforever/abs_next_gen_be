class AddEmergencyColumnsToParents < ActiveRecord::Migration[5.2]
  def change
    add_column :parents, :emergency_contact, :text
    add_column :parents, :emergency_contact_phone_number, :text
  end
end
