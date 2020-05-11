# frozen_string_literal: true

ActiveAdmin.register CollectionPoint do
  permit_params :coordinator_id,
                :name,
                address_attributes: %i[
                  id
                  line_1
                  line_2
                  locality
                  administrative_area
                  postal_code
                  country
                ],
                inventory_lines_attributes: %i[
                  id
                  product_id
                  quantity_present
                  inventoried_type
                  inventoried_id
                ]
  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    tabs do
      tab t("collection_point.info") do
        f.inputs do
          f.input :coordinator
          f.input :name
          f.has_many :address, new_record: !f.object.address do |af|
            af.input :line_1
            af.input :line_2
            af.input :locality
            af.input :administrative_area, as: :select, collection: Address::REGIONS
            af.input :postal_code
            af.input :country, priority_countries: ["Peru"]
          end
          f.actions
        end
      end

      tab t("collection_point.inventory") do
        f.inputs do
          f.has_many :inventory_lines do |ilf|
            ilf.input :product
            ilf.input :quantity_present
          end
        end
        f.actions
      end
    end
  end

  show do |collection_point|
    attributes_table do
      row :coordinator
      row :address
    end

    panel t("activerecord.models.order.other") do
      table_for collection_point.orders do
        column :id do |order|
          link_to order.id, admin_order_path(order)
        end
        column :external_entity
        column t("activerecord.attributes.order.state") do |o|
          t("orders.state.#{o.state}")
        end
        column :updated_at
      end

    end

    columns do
      column max_width: "300px" do
        h2 t("collection_point.inventory")
        table_for collection_point.inventory_lines do
          column :product
          column t("quantity"), :quantity_present
        end
      end

      column max_width: "300px" do
        h2 t("outlays")
        table_for collection_point.origin_receipts do
          column t("date") do |receipt|
            link_to receipt.created_at, admin_receipt_path(receipt)
          end
          column :destination
          column :state do |receipt|
            t("receipts.state.#{receipt.state}")
          end
        end
      end

      column max_width: "300px" do
        h2 t("intakes")
        table_for collection_point.destination_receipts do
          column t("date") do |receipt|
            link_to receipt.created_at, admin_receipt_path(receipt)
          end
          column :origin
          column :state do |receipt|
            t("receipts.state.#{receipt.state}")
          end
        end
      end
    end
  end
end
