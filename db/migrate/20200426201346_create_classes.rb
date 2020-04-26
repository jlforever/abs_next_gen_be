class CreateClasses < ActiveRecord::Migration[5.2]
  def change
    create_table :classes do |t|
      t.references :specialty, null: false, index: true, foreign_key: true
      t.references :faculty, null: false, index: true, foreign_key: true
      t.bigint :total_cost, null: false
      t.bigint :faculty_cut, null: false
      t.text :taught_via, null: false
      t.text :phyiscal_location_address
      t.bigint :number_of_weeks, null: false
      t.bigint :occurs_on_for_a_given_week, null: false
      t.text :individual_session_starts_at, null: false
      t.bigint :per_session_minutes, null: false
      t.datetime :effective_from, null: false
      t.datetime :effective_unitl

      t.timestamps null: false
    end
  end
end
