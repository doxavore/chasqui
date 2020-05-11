# frozen_string_literal: true

class InventoryLine < ApplicationRecord
  belongs_to :inventoried, polymorphic: true
  belongs_to :product
  attribute :quantity_present, :integer, default: 0
  attribute :quantity_desired, :integer, default: 0

  def quantity_remaining
    quantity_desired - quantity_present
  end
end
