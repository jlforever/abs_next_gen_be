class RenameTypoUsersEmergencyContactPhonColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :emergency_contact_phon_number, :emergency_contact_phone_number
  end
end
