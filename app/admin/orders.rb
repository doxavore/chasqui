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

  show do
    columns do
      column max_width: "600px" do
        attributes_table do
          row :external_entity
          row :created_at
          row :updated_at
        end

        table_for order.inventory_lines do
          column :product
          column t("quantity_delivered"), :quantity_present
          column t("quantity_ordered"), :quantity_desired
        end
      end
    end
  end
end
