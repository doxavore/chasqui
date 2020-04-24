# frozen_string_literal: true

class ExternalEntity < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :inventory_lines, through: :orders
  belongs_to :user
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true

  def to_s
    "#{name} (#{address&.administrative_area})"
  end

  # this is a special case since we don't want to create orders
  def credit_receipt(receipt)
    receipt.inventory_lines.each do |r_line|
      remaining = r_line.quantity_present
      inventory_lines.where(product: r_line.product).find_each do |o_line|
        debit_quantity = [remaining, o_line.quantity_remaining].min
        break if debit_quantity.zero?

        remaining -= debit_quantity
        o_line.quantity_present += debit_quantity
        o_line.save
      end
    end
  end

end
