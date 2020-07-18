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

  def receipt_identifier
    "#{self.class}-#{id}"
  end

  # this is a special case since we don't want to create inventory lines
  def credit_receipt(receipt)
    inv_map = receipt.inventory_lines.map { |i| [i.product_id, i.quantity_present] }.to_h
    # fullfill orders for recipes first
    orders_for_receipts.assigned.find_each do |order|
      order.inventory_lines.each do |o_line|
        next unless o_line.product.product_recipes.any?

        o_line.product.credit_to_line(o_line, inv_map)
      end
      order.complete! if order.can_complete?
    end

    orders_for_receipts.assigned.find_each do |order|
      order.inventory_lines.each do |o_line|
        o_line.product.credit_to_line(o_line, inv_map)
      end
      order.complete! if order.can_complete?
    end
  end

  def debit_receipt(receipt)
    inv_map = receipt.inventory_lines.map { |i| [i.product_id, i.quantity_present] }.to_h
    # fullfill orders for recipes first
    orders_for_receipts.where(state: %w[completed assigned]).find_each do |order|
      order.inventory_lines.each do |o_line|
        next unless o_line.product.product_recipes.any?

        o_line.product.debit_from_line(o_line, inv_map)
      end
      order.uncomplete! if order.completed?
    end

    orders_for_receipts.where(state: %w[completed assigned]).find_each do |order|
      order.inventory_lines.each do |o_line|
        o_line.product.debit_from_line(o_line, inv_map)
      end
      order.uncomplete! if order.completed?
    end
  end

  def orders_for_receipts
    orders.includes(inventory_lines: { product: { product_recipes: :ingredients } })
  end
end
