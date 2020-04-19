# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :email,
                :password,
                :password_confirmation,
                :admin,
                :first_name,
                :last_name,
                :company,
                :phone,
                :address_id,
                :coordinator_id,
                printer_ids: [],
                printers_attributes: %i[id name printer_model_id],
                address_attribute: %i[
                  id
                  line_1
                  line_2
                  locality
                  administrative_area
                  postal_code
                  country
                ]

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :phone
    column :company
    actions
  end

  filter :email
  filter :phone

  form do |f|
    tabs do
      tab "Datos" do
        f.inputs "Basicos" do
          f.input :email
          f.input :first_name
          f.input :last_name
          f.input :phone
          f.input :company
          f.input :admin
          f.input :password
          f.input :password_confirmation
          f.input :coordinator
        end

        f.inputs "Direccion" do
          f.has_many :address do |af|
            af.input :line_1
            af.input :line_2
            af.input :locality
            af.input :administrative_area
            af.input :postal_code
            af.input :country, priority_countries: ["Peru"]
          end
        end
      end

      tab "Configuracion" do
        f.inputs do
          f.has_many :printers do |pf|
            pf.input :name
            pf.input :printer_model
          end
        end
      end
    end
    f.actions
  end

  controller do
    def update
      model = :user
      %w[password password_confirmation].each { |p| params[model].delete(p) } if params[model][:password].blank?

      super
    end
  end
end
