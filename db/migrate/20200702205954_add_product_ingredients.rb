class AddProductIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :product_recipes do |t|
      t.string :name
      t.references :product, index: true, null: false
    end

    create_table :ingredients do |t|
      t.integer :quantity
      t.references :product_recipe, index: true, null: false
      t.references :product, index: true, null: false
    end
  end
end
