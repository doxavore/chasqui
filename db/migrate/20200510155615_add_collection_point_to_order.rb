class AddCollectionPointToOrder < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :collection_point, foreign_key: { to_table: :collection_points }, index: true
  end
end
