# frozen_string_literal: true

class ExternalEntity < ApplicationRecord
  include Taggable
  has_many :orders, dependent: :destroy
  has_many :inventory_lines, through: :orders
  has_many :external_entity_users, dependent: :destroy
  has_many :users, through: :external_entity_users
  has_one :address, as: :addressable, dependent: :destroy
  has_many :origin_receipts, as: :origin, class_name: "Receipt", dependent: :nullify
  has_many :destination_receipts, as: :destination, class_name: "Receipt", dependent: :nullify
  accepts_nested_attributes_for :address, allow_destroy: true
  has_many :product_providers, dependent: :destroy
  accepts_nested_attributes_for :product_providers, allow_destroy: true

  def to_s
    "#{name} (#{address&.administrative_area})"
  end

  # this is a special case since we don't want to create inventory lines
  def credit_receipt(receipt)
    inv_map = receipt.inventory_lines.map{ |i| [i.product_id, i.quantity_present] }.to_h
    receipt.inventory_lines.each do |r_line|
      remaining = r_line.quantity_present

      orders.includes(:inventory_lines).assigned.each do |order|
        break if remaining.zero?

        order.inventory_lines.each do |o_line|
          next if o_line.product_id != r_line.product_id

          debit_quantity = [remaining, o_line.quantity_remaining].min
          next if debit_quantity.zero?

          remaining -= debit_quantity
          o_line.quantity_present += debit_quantity
          o_line.save
        end
        order.complete! if order.can_complete?
      end
    end
  end

  def debit_receipt(receipt)
    receipt.inventory_lines.each do |r_line|
      remaining = r_line.quantity_present

      orders.includes(:inventory_lines).where(state: %w[completed assigned]).find_each do |order|
        break if remaining.zero?

        order.inventory_lines.each do |o_line|
          next if o_line.product_id != r_line.product_id

          debit_quantity = [remaining, o_line.quantity_present].min
          next if debit_quantity.zero?

          remaining -= debit_quantity
          o_line.quantity_present -= debit_quantity
          o_line.save
        end
        order.uncomplete! if order.completed?
      end
    end
  end
end
