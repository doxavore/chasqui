# frozen_string_literal: true

ActiveAdmin.register ExternalEntity do
  includes :tags, :address

  permit_params :name,
                :ruc,
                tag_ids: [],
                user_ids: [],
                address_attributes: %i[
                  id
                  line_1
                  line_2
                  locality
                  administrative_area
                  postal_code
                  country
                ]

  filter :name
  filter :user
  filter :address_administrative_area,
         as: :string,
         label: proc { I18n.t("activerecord.attributes.address.administrative_area") }
  filter :tags

  index do
    id_column
    column :name
    column :ruc
    column t("activerecord.attributes.address.administrative_area") do |u|
      u.address&.administrative_area
    end

    column t("activerecord.attributes.address.locality") do |u|
      u.address&.locality
    end

    column :tags do |obj|
      obj.tags.each do |tag|
        status_tag(tag.name, style: "background-color: #{tag.color}")
      end
      nil
    end
  end

  show do
    ee = external_entity
    h3 ee.name
    attributes_table do
      row :users do |obj|
        obj.users.each do |user|
          render "/admin/user/card", { user: user }
        end
        nil
      end
      row :ruc
      row :address
      row :tags do |obj|
        obj.tags.each do |tag|
          status_tag(tag.name, style: "background-color: #{tag.color}")
        end
        nil
      end
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

    active_admin_comments
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs do
      f.input :user_ids,
              as: :selected_list,
              display_name: :name,
              fields: %i[first_name last_name email],
              collection: User.all,
              label: t("activerecord.attributes.external_entity.users")
      f.input :name
      f.input :tag_ids, as: :tags, collection: Tag.all, label: t("activerecord.attributes.external_entity.tags")
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
end
