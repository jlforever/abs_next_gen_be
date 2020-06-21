class AddRegistrationsKlassAndPrimaryFamilyMemberUniqueIndex < ActiveRecord::Migration[5.2]
  def up
  	add_index :registrations, [:klass_id, :primary_family_member_id], unique: true, name: 'idx_registrations_on_uniq_klass_primary_family_member'
  end

  def down
  	# not a reversible index to remove
  end
end
