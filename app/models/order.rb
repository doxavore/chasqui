# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :external_entity
  has_many :inventory_lines, as: :inventoried, dependent: :destroy
  accepts_nested_attributes_for :inventory_lines, allow_destroy: true
end
