# frozen_string_literal: true

class Product < ApplicationRecord
  scope :producible, -> { where(producible: true) }
  scope :orderable, -> { where(orderable: true) }
  has_many :inventory_lines, dependent: :destroy
end
