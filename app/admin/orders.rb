# frozen_string_literal: true

ActiveAdmin.register Order do
  includes :external_entity, :tags, :address
  permit_params :external_entity_id, :collection_point_id,
                tag_ids: [],
                inventory_lines_attributes: %i[id product_id quantity_desired _destroy]

  filter :state, collection: proc { Order.aasm.states.map { |s| [t("orders.state.#{s}"), s] } }, as: :select
  filter :updated_at, as: :date_range
  filter :external_entity
  filter :external_entity_address_administrative_area,
         as: :string,
         label: proc { I18n.t("activerecord.attributes.address.administrative_area") }
  filter :tags

  index do
    id_column
    column :external_entity
    column t("activerecord.attributes.address.administrative_area") do |u|
      u.external_entity.address&.administrative_area
    end
    state_column(
      :state,
      states: Order.aasm.states.map(&:name).index_with(&:to_s)
    )
    column :collection_point
    column :updated_at
    column :tags do |obj|
      obj.tags.each do |tag|
        status_tag(tag.name, style: "background-color: #{tag.color}")
      end
      nil
    end
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
          row :tags do |obj|
            obj.tags.each do |tag|
              status_tag(tag.name, style: "background-color: #{tag.color}")
            end
            nil
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

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :external_entity
      f.input :collection_point
      f.input :tag_ids, as: :tags, collection: Tag.all, label: t("activerecord.attributes.order.tags")
      f.has_many :inventory_lines, allow_destroy: true do |ilf|
        ilf.input :product, collection: Product.producible
        ilf.input :quantity_desired
      end
    end
    f.actions
  end

  member_action :approve, method: :put do
    resource.approve!
    redirect_to resource_path(resource), notice: t("orders.approved")
  end

  action_item :approve, only: :show, if: proc { order.pending_approval? } do
    link_to t("orders.approve"), approve_admin_order_path(order), method: :put
  end
end
