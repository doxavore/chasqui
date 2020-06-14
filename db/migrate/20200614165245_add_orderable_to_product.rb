class AddOrderableToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :orderable, :boolean
  end
end
