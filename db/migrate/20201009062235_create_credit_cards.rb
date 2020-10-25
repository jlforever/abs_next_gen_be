class CreateCreditCards < ActiveRecord::Migration[5.2]
  def change
    create_table :credit_cards do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.text :card_holder_name, null: false
      t.text :card_last_four, null: false
      t.text :card_type, null: false
      t.text :card_expire_month, null: false
      t.text :card_expire_year, null: false
      t.text :stripe_customer_token
      t.text :stripe_card_token
      t.text :postal_identification

      t.timestamps null: false
    end
  end
end
