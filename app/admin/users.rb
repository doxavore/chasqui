# frozen_string_literal: true

ActiveAdmin.register User do
  includes :address, :tags, :printers
  scope I18n.t("users.all"), :all, default: true
  scope I18n.t("users.admins"), :admins
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
                :status,
                :profession,
                printer_ids: [],
                tag_ids: [],
                printers_attributes: %i[id name printer_model_id _destroy],
                address_attributes: %i[
                  id
                  line_1
                  line_2
                  locality
                  administrative_area
                  postal_code
                  country
                ],
                product_assignments_attributes: %i[id product_id _destroy]

  filter :email
  filter :phone
  filter :first_name
  filter :last_name
  filter :status
  filter :address_administrative_area,
         as: :string,
         label: proc { I18n.t("activerecord.attributes.address.administrative_area") }
  filter :tags
  filter :has_printers, as: :boolean, label: proc { I18n.t("users.has_printers") }

  index do
    selectable_column
    id_column
    column t("activerecord.attributes.address.administrative_area") do |u|
      u.address&.administrative_area
    end

    column t("activerecord.attributes.address.locality") do |u|
      u.address&.locality
    end
    column :first_name
    column :last_name
    column :email
    column :phone
    column :company
    column :created_at
    column :tags do |obj|
      obj.tags.each do |tag|
        status_tag(tag.name, style: "background-color: #{tag.color}")
      end
      nil
    end

    column :printers do |obj|
      obj.printers.count
    end
  end

  show do
    attributes_table do
      row :email
      row :status
      row :profession
      row :first_name
      row :last_name
      row :phone
      row :address
      row :last_sign_in_at
      row t("activerecord.attributes.user.product_assignments") do |u|
        u.product_assignments.map(&:product).map(&:name)
      end
      row :printers
      row :tags do |u|
        u.tags.each do |tag|
          status_tag(tag.name, style: "background-color: #{tag.color}")
        end
        nil
      end
    end

    columns do
      column max_width: "300px" do
        h2 t("collection_point.inventory")
        table_for user.inventory_lines do
          column :product
          column t("quantity"), :quantity_present
        end
      end

      column max_width: "300px" do
        h2 t("outlays")
        table_for user.origin_receipts.completed do
          column t("active_admin.date") do |receipt|
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
        table_for user.destination_receipts.completed do
          column t("active_admin.date") do |receipt|
            link_to receipt.created_at, admin_receipt_path(receipt)
          end
          column :origin
          column :state do |receipt|
            t("receipts.state.#{receipt.state}")
          end
        end
      end
    end

    active_admin_comments
  end

  form do |f|
    f.semantic_errors
    tabs do
      tab t("users.info") do
        f.inputs t("users.basic") do
          f.input :email
          f.input :first_name
          f.input :last_name
          f.input :phone
          f.input :company
          f.input :admin if current_user.admin?
          f.input :status if current_user.admin?
          f.input :profession
          f.input :password
          f.input :password_confirmation
          f.input :coordinator if current_user.admin?
          if current_user.admin?
            f.input :tag_ids, as: :tags, collection: Tag.all, label: t("activerecord.attributes.order.tags")
          end
        end

        f.inputs t("activerecord.models.address.one") do
          f.has_many :address, new_record: !f.object.address do |af|
            af.input :line_1
            af.input :line_2
            af.input :locality
            af.input :administrative_area, as: :select, collection: Address::REGIONS
            af.input :postal_code
            af.input :country, priority_countries: ["Peru"]
          end
        end
      end

      tab t("users.config") do
        f.inputs do
          f.has_many :printers do |pf|
            pf.input :name
            pf.input :printer_model
          end
        end
      end
      if current_user.admin?
        tab t("users.production") do
          f.inputs do
            f.has_many :product_assignments, allow_destroy: true do |paf|
              paf.input :product, collection: Product.producible
            end
          end
          f.has_many :inventory_lines, allow_destroy: true do |inv|
            inv.input :product
            inv.input :quantity_present, label: t("quantity")
          end
        end
      end
    end
    f.actions
  end

  csv do
    column :id
    column :first_name
    column :last_name
    column :email
    column(:tags) { |u| u.tags.map(&:name).join(" ") }
    column("Departamento") { |u| u.address&.administrative_area }
    column :address
  end

  controller do
    def update # rubocop:disable Metrics/AbcSize
      model = :user
      %w[password password_confirmation].each { |p| params[model].delete(p) } if params[model][:password].blank?
      params[:user][:email_confirmation] = params[:user][:email]
      params[:user][:phone_confirmation] = params[:user][:phone]
      params[:user][:tag_ids] = params[:user][:tag_ids].reject(&:empty?) if params[:user][:tag_ids]
      params[:user] = params[:user].slice(*policy(resource).permitted_attributes)
      super
    end
  end

  before_save do |user|
    user.skip_confirmation!
    user.skip_reconfirmation!
  end
end
