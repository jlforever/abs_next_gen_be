class CreateRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :registrations do |t|
      t.references :class, null: false, index: true, foreign_key: true
      t.bigint :primary_family_member_id, index: true
      t.bigint :secondary_family_member_id, index: true
      t.bigint :tertiary_family_member_id,  index: true
      t.text :status, null: false, default: 'processing'
      t.bigint :total_due, null: false
      t.datetime :total_due_by, null: false

      t.timestamps null: false
    end
  end
end
