# frozen_string_literal: true

class ProductProvider < ApplicationRecord
  belongs_to :external_entity
  belongs_to :product
end
