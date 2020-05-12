class ExpandAddressForParents < ActiveRecord::Migration[5.2]
  def up
    remove_column :parents, :address
    add_column :parents, :address1, :text
    add_column :parents, :address2, :text
    add_column :parents, :city, :text
    add_column :parents, :state, :text
    add_column :parents, :zip, :text
  end

  def down
    remove_column :parents, :address1
    remove_column :parents, :address2
    remove_column :parents, :city
    remove_column :parents, :state
    remove_column :parents, :zip
    add_column :parents, :address, :text
  end
end
