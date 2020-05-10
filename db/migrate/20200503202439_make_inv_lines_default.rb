class MakeInvLinesDefault < ActiveRecord::Migration[6.0]
  def change
    InventoryLine.where(quantity_present: nil).update_all(quantity_present: 0)
    InventoryLine.where(quantity_desired: nil).update_all(quantity_desired: 0)
    change_column_default(:inventory_lines, :quantity_present, from: nil, to: 0)
    change_column_default(:inventory_lines, :quantity_desired, from: nil, to: 0)
    change_column_null(:inventory_lines, :quantity_desired, false)
    change_column_null(:inventory_lines, :quantity_present, false)
  end
end
