# frozen_string_literal: true

ActiveAdmin.register Receipt do
  permit_params :origin_identifier,
                :destination_identifier,
                inventory_lines_attributes: %i[id product_id quantity_present]
  form do |f|
    f.inputs do
      f.input :origin_identifier, collection: Receipt.participants.map { |i| [i.to_s, "#{i.class}-#{i.id}"] }
      f.input :destination_identifier, collection: Receipt.participants.map { |i| [i.to_s, "#{i.class}-#{i.id}"] }
      f.has_many :inventory_lines, allow_destroy: true do |inv|
        inv.input :product
        inv.input :quantity_present, label: t("quantity")
      end
    end

    f.actions
  end
end
