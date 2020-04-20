# frozen_string_literal: true

ActiveAdmin.register Order do
  permit_params :external_entity_id,
                inventory_lines_attributes: %i[id product_id quantity_desired _destroy]

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :external_entity
      f.has_many :inventory_lines, allow_destroy: true do |ilf|
        ilf.input :product, collection: Product.producible
        ilf.input :quantity_desired
      end
    end
    f.actions
  end
end
