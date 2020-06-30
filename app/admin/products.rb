# frozen_string_literal: true

ActiveAdmin.register Product do
  includes :product_providers, :external_entities
  permit_params :name,
                :producible,
                :orderable,
                product_providers_attributes: %i[
                  id
                  external_entity_id
                  brand
                  price
                  discount
                  stock
                  notes
                ]
  show do
    attributes_table do
      row :name
      row :producible
      row :orderable
    end

    panel t("activerecord.attributes.product.product_providers") do
      table_for product.product_providers do
        column :external_entity
        column :brand
        column :price
        column :discount
        column :stock
        column :notes
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs do
      f.input :name
      f.input :producible
      f.input :orderable

      f.has_many :product_providers,
                 heading: t("activerecord.attributes.product.product_providers"),
                 new_record: t("add_provider") do |pf|
        pf.input :external_entity
        pf.input :brand
        pf.input :price
        pf.input :discount
        pf.input :stock
        pf.input :notes
      end
    end

    f.actions
  end
end
