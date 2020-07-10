# frozen_string_literal: true

class Product < ApplicationRecord
  scope :producible, -> { where(producible: true) }
  scope :orderable, -> { where(orderable: true) }
  has_many :inventory_lines, dependent: :destroy
  has_many :product_providers, dependent: :destroy
  has_many :external_entities, through: :product_providers
  accepts_nested_attributes_for :product_providers, allow_destroy: true
  has_many :product_recipes
end
