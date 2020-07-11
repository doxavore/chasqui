# frozen_string_literal: true

ActiveAdmin.register ProductRecipe do
  includes :product, :ingredients
  permit_params :name,
                :product_id,
                ingredients_attributes: %i[
                  id
                  product_id
                  quantity
                  _destroy
                ]
  show do
    attributes_table do
      row :name
      row :product
    end

    panel t("activerecord.attributes.product_recipe.ingredients") do
      table_for product_recipe.ingredients do
        column :product
        column :quantity
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs do
      f.input :name
      f.input :product

      f.has_many :ingredients,
                 allow_destroy: true,
                 heading: t("activerecord.attributes.product_recipe.ingredients"),
                 new_record: true do |pf|
        pf.input :product
        pf.input :quantity
      end
    end

    f.actions
  end
end
