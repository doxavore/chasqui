class AddLegacyOrderNumber < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :legacy_order_number, :string
  end
end
