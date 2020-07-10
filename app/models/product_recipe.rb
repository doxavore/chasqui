# frozen_string_literal: true

class ProductRecipe < ApplicationRecord
  belongs_to :product
  has_many :ingredients
end
