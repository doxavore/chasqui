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
  end
end
