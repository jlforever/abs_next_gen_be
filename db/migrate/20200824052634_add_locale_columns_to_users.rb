class AddLocaleColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :address1, :text
    add_column :users, :address2, :text
    add_column :users, :city, :text
    add_column :users, :state, :text
    add_column :users, :zip, :text
  end
end
