class RemoveAddressNotNullForParents < ActiveRecord::Migration[5.2]
  def up
    change_column_null(:parents, :address, true)
  end

  def down
    # not reversible down migration
  end
end
