class ChangeKlassesOccursOnToText < ActiveRecord::Migration[5.2]
  def change
    change_column :klasses, :occurs_on_for_a_given_week, :text
  end
end
