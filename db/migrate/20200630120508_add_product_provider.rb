class AddProductProvider < ActiveRecord::Migration[6.0]
  def change
    create_table :product_providers do |t|
      t.references :external_entity, index: true, null: false
      t.references :product, index: true, null: false
      t.string :brand
      t.decimal :price, precision: 10, scale: 3
      t.decimal :discount, precision: 10, scale: 3
      t.integer :stock
      t.string :notes
    end
  end
end
