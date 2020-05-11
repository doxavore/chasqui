# frozen_string_literal: true

ActiveAdmin.register ExternalEntity do
  permit_params :user_id,
                :name,
                address_attributes: %i[
                  id
                  line_1
                  line_2
                  locality
                  administrative_area
                  postal_code
                  country
                ]
  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs do
      f.input :user
      f.input :name
      f.has_many :address, new_record: !f.object.address do |af|
        af.input :line_1
        af.input :line_2
        af.input :locality
        af.input :administrative_area, as: :select, collection: Address::REGIONS
        af.input :postal_code
        af.input :country, priority_countries: ["Peru"]
      end
    end

    f.actions
  end

  show do
    ee = external_entity
    h3 ee.name
    attributes_table do
      row :user
      row :address
    end

    panel t("activerecord.models.order.other") do
      table_for external_entity.orders do
        column :id do |order|
          link_to order.id, admin_order_path(order)
        end
        column :collection_point
        column t("activerecord.attributes.order.state") do |o|
          t("orders.state.#{o.state}")
        end
        column :updated_at
      end

    end

    panel t("intakes") do
      table_for external_entity.destination_receipts do
        column t("active_admin.date") do |receipt|
          link_to receipt.created_at, admin_receipt_path(receipt)
        end

        column :state do |receipt|
          t("receipts.state.#{receipt.state}")
        end
      end
    end

    panel t("outlays") do
      table_for external_entity.origin_receipts do
        column t("active_admin.date") do |receipt|
          link_to receipt.created_at, admin_receipt_path(receipt)
        end

        column :state do |receipt|
          t("receipts.state.#{receipt.state}")
        end
      end
    end
  end
end
