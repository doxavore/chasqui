# frozen_string_literal: true

class InventoryLine < ApplicationRecord
  has_paper_trail
  belongs_to :inventoried, polymorphic: true, touch: true
  belongs_to :product
  attribute :quantity_present, :integer, default: 0
  attribute :quantity_desired, :integer, default: 0

  def quantity_remaining
    quantity_desired - quantity_present
  end

  def to_h
    {
      id: id,
      product: product.to_s,
      quantity_present: quantity_present,
      quantity_desired: quantity_desired
    }
  end

  def complete?
    !quantity_remaining.positive?
  end
end
