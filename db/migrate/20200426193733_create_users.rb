class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.text :email, null: false, index: { unique: true }
      t.text :first_name, null: false
      t.text :last_name, null: false
      t.text :user_name, null: false
      t.text :phone_number, null: false
      t.text :emergency_contact, null: false
      t.text :emergency_contact_phon_number, null: false
      t.text :timezone

      t.timestamps null: false
    end
  end
end
