# frozen_string_literal: true

class Ingredient < ApplicationRecord
  belongs_to :product_recipe
  belongs_to :product
end
