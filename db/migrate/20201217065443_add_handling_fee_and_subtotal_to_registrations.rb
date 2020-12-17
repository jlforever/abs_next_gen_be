class AddHandlingFeeAndSubtotalToRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_column :registrations, :handling_fee, :integer, null: false, default: 0
    add_column :registrations, :subtotal, :integer, null: false, default: 0
  end
end
