# frozen_string_literal: true

class Product < ApplicationRecord
  scope :producible, -> { where(producible: true) }
  has_many :inventory_lines, dependent: :destroy
end
