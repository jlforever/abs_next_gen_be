class LiftSomeNonNullConstraintsOnUsers < ActiveRecord::Migration[5.2]
  def up
    [
      :first_name,
      :last_name,
      :user_name,
      :phone_number,
      :emergency_contact, 
      :emergency_contact_phon_number
    ].each do |column|
      change_column_null(:users, column, true)
    end
  end

  def down
    # not reversible down migration
  end
end
