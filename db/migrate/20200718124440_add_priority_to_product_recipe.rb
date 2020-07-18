class AddPriorityToProductRecipe < ActiveRecord::Migration[6.0]
  def change
    add_column :product_recipes, :priority, :integer
  end
end
