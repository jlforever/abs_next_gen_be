class CreateRegistrationCreditCardCharges < ActiveRecord::Migration[5.2]
  def change
    create_table :registration_credit_card_charges do |t|
      t.references :registration, null: false, index: { name: 'idx_reg_credit_card_charge_on_reg' }, foreign_key: true
      t.references :credit_card, null: false, index: { name: 'idx_reg_credit_card_charge_on_credit_card' }, foreign_key: true
      t.text :charge_id, null: false
      t.integer :amount, null: false
      t.jsonb :charge_outcome, null: false, default: {}

      t.timestamps null: false
    end
  end
end
