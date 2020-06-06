class AddMoreAttributesToKlasses < ActiveRecord::Migration[5.2]
  def change
    add_column :klasses, :one_sibling_same_class_discount_rate, :float
    add_column :klasses, :two_siblings_same_class_discount_rate, :float
    add_column :klasses, :virtual_klass_platform_link, :text
  end
end
