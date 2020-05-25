class AddFieldsToReceipts < ActiveRecord::Migration[6.0]
  def change
    add_column :receipts, :delivered_at, :timestamp
  end
end
