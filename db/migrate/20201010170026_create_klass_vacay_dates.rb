class CreateKlassVacayDates < ActiveRecord::Migration[5.2]
  def change
    create_table :klass_vacay_dates do |t|
      t.references :klass, null: false, index: true, foreign_key: true
      t.text :off_date, null: false

      t.timestamps null: false
    end
  end
end
