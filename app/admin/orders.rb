# frozen_string_literal: true

ActiveAdmin.register Order do
  permit_params :external_entity_id, :collection_point_id,
                inventory_lines_attributes: %i[id product_id quantity_desired _destroy]

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :external_entity
      f.input :collection_point
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
          row :state do |order|
            t("orders.state.#{order.state}")
          end
        end

        table_for order.inventory_lines do
          column :product
          column t("quantity_delivered"), :quantity_present
          column t("quantity_ordered"), :quantity_desired
        end
      end
    end

    active_admin_comments
  end

  index do
    id_column
    column :external_entity
    column t("activerecord.attributes.order.state") do |o|
      t("orders.state.#{o.state}")
    end
    column :collection_point
    column :updated_at
  end

  member_action :approve, method: :put do
    resource.approve!
    redirect_to resource_path(resource), notice: t("orders.approved")
  end

  action_item :approve, only: :show, if: proc { order.pending_approval? } do
    link_to t("orders.approve"), approve_admin_order_path(order), method: :put
  end
end
