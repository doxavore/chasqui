# frozen_string_literal: true

ActiveAdmin.register Tag do
  permit_params :name, :color, :description

  index do
    id_column
    column :name do |t|
      status_tag(t.name, style: "background-color: #{t.color}")
    end
    column :description
    actions
  end

  filter :name
end
