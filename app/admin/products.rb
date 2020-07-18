# frozen_string_literal: true

ActiveAdmin.register Product do
  includes :product_providers, :external_entities
  permit_params :name,
                :producible,
                :orderable,
                :image,
                product_providers_attributes: %i[
                  id
                  external_entity_id
                  brand
                  price
                  discount
                  stock
                  notes
                  _destroy
                ]
  filter :name
  filter :producible
  filter :orderable

  index do
    id_column
    column :image do |prod|
      img src: url_for(prod.image.variant(resize_to_limit: [150, 150])) if prod.image.present?
    end
    column :name
    column :producible
    column :orderable
  end

  show do
    attributes_table do
      row :name
      row :image do |prod|
        if prod.image.present?
          a href: url_for(prod.image) do
            img src: url_for(prod.image.variant(resize_to_limit: [300, 300]))
          end
        end
      end
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
      f.input :image, as: :file

      f.has_many :product_providers,
                 allow_destroy: true,
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
