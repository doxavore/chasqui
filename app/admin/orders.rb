# frozen_string_literal: true

ActiveAdmin.register Order do
  scope I18n.t("active"), :active, default: true
  scope I18n.t("voided"), :voided
  includes :external_entity, :tags, :address
  permit_params :external_entity_id, :collection_point_id, :user_id,
                tag_ids: [],
                inventory_lines_attributes: %i[id product_id quantity_desired _destroy]

  filter :state, collection: proc { Order.aasm.states.map { |s| [t("orders.state.#{s}"), s] } }, as: :select
  filter :updated_at, as: :date_range
  filter :external_entity
  filter :external_entity_address_administrative_area,
         as: :string,
         label: proc { I18n.t("activerecord.attributes.address.administrative_area") }
  filter :tags

  config.clear_action_items!
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
    column :user
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
          row :user do |order|
            render "/admin/user/card", { user: order.user } if order.user
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
      f.input :user
      f.input :tag_ids, as: :tags, collection: Tag.all, label: t("activerecord.attributes.order.tags")
      f.has_many :inventory_lines, allow_destroy: true do |ilf|
        ilf.input :product, collection: Product.all
        ilf.input :quantity_desired
      end
    end
    f.actions
  end

  csv do
    column :id
    column(t("activerecord.models.external_entity.one"), &:external_entity)
    column(t("activerecord.attributes.user.phone")) { |order| order.external_entity.user.phone }
    column(:email) { |order| order.external_entity.user.email }
    column(t("activerecord.attributes.external_entity.address")) { |order| order.external_entity.address }
    column(:pedidos) do |order|
      order.inventory_lines.map { |l| "#{l.product.name} - #{l.quantity_desired}" }.join(", ")
    end
    column(:pendientes) do |order|
      order.inventory_lines.map { |l| "#{l.product.name} - #{l.quantity_remaining}" }.join(", ")
    end
  end

  member_action :approve, method: :put do
    resource.approve!
    redirect_to resource_path(resource), notice: t("orders.approved")
  end

  member_action :void, method: :put do
    resource.void!
    redirect_to resource_path(resource), notice: t("orders.voided")
  end

  collection_action :reconcile, method: :put do
    Order.reconcile

    redirect_to collection_path, notice: t("orders.reconciled")
  end

  action_item :approve, only: :show, if: proc { order.pending_approval? } do
    link_to t("orders.approve"), approve_admin_order_path(order), method: :put
  end

  action_item :void, only: :show do
    link_to t("orders.void"), void_admin_order_path(order), method: :put
  end

  action_item :edit, only: :show do
    link_to t("orders.edit"), edit_admin_order_path(order), method: :get
  end

  action_item :new, only: :index do
    link_to t("orders.new"), new_admin_order_path, method: :get
  end

  action_item :reconcile, only: :index do
    link_to t("orders.reconcile"), reconcile_admin_orders_path, method: :put
  end
end
