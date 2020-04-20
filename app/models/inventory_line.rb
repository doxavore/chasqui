# frozen_string_literal: true

class InventoryLine < ApplicationRecord
  belongs_to :inventoried, polymorphic: true
  belongs_to :product
end
