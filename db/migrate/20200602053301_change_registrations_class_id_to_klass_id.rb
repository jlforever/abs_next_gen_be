class ChangeRegistrationsClassIdToKlassId < ActiveRecord::Migration[5.2]
  def change
  	rename_column :registrations, :class_id, :klass_id
  end
end
