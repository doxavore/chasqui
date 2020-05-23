# frozen_string_literal: true

ActiveAdmin.register Receipt do
  config.clear_action_items!

  filter :state, collection: proc { Receipt.aasm.states.map { |s| [t("receipts.state.#{s}"), s] } }, as: :select
  filter :updated_at, as: :date_range

  permit_params :origin_identifier,
                :destination_identifier,
                :image,
                inventory_lines_attributes: %i[id product_id quantity_present _destroy]
  form do |f|
    if f.object.draft?
      f.inputs do
        f.input :origin_identifier, collection: Receipt.participants.map { |i| [i.to_s, "#{i.class}-#{i.id}"] }
        f.input :destination_identifier, collection: Receipt.participants.map { |i| [i.to_s, "#{i.class}-#{i.id}"] }
        f.has_many :inventory_lines, allow_destroy: true do |inv|
          inv.input :product
          inv.input :quantity_present, label: t("quantity")
        end
      end
    elsif f.object.delivering?
      f.inputs do
        f.input :image, as: :file
      end
    end

    f.actions
  end

  index do
    id_column
    state_column(
      :state,
      states: Order.aasm.states.map(&:name).index_with(&:to_s)
    )
    column :updated_at
    column :origin
    column :destination
  end

  show do
    h2 t("receipts.origin", origin: receipt.origin)
    h2 t("receipts.destination", destination: receipt.destination)
    h2 t("activerecord.attributes.receipt.state") + ": " + t("receipts.state.#{receipt.state}")
    if receipt.image.present?
      a href: url_for(receipt.image) do
        img src: url_for(receipt.image), style: "max-width: 400p; max-height: 400px"
      end
    else
      i t("receipts.completion_instructions")
    end
    columns do
      column max_width: "600px" do
        table_for receipt.inventory_lines do
          column :product
          column t("quantity"), :quantity_present
        end
      end
    end
  end

  action_item :complete, only: :show, if: proc { receipt.delivering? && receipt.image.present? } do
    link_to t("receipts.complete"), complete_admin_receipt_path(receipt), method: :put
  end

  action_item :deliver, only: :show, if: proc { receipt.draft? } do
    link_to t("receipts.deliver"), begin_delivery_admin_receipt_path(receipt), method: :put
  end

  action_item :void, only: :show, if: proc { receipt.draft? || receipt.delivering? } do
    link_to t("receipts.void"), void_admin_receipt_path(receipt), method: :put
  end

  action_item :edit, only: :show, if: proc { receipt.draft? || receipt.delivering? } do
    link_to t("receipts.edit"), edit_admin_receipt_path(receipt), method: :get
  end

  action_item :new, only: :index do
    link_to t("receipts.new"), new_admin_receipt_path, method: :get
  end

  member_action :complete, method: :put do
    resource.complete!
    redirect_to resource_path(resource), notice: t("receipts.completed")
  end

  member_action :begin_delivery, method: :put do
    resource.begin_delivery!
    redirect_to resource_path(resource), notice: t("receipts.delivery_begun")
  end

  member_action :void, method: :put do
    resource.void!
    redirect_to resource_path(resource), notice: t("receipts.voided"), data: { confirm: t("receipts.confirm_void") }
  end

  action_item :history, only: :show do
    link_to t("history"), history_admin_receipt_path(receipt), method: :get
  end

  member_action :history do
    @receipt = Receipt.find(params[:id])
    @versions = PaperTrail::Version.where(item_type: "Receipt", item_id: @receipt.id)
    render "layouts/history"
  end
end
