# frozen_string_literal: true

class CollectionPoint < ApplicationRecord
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true
  belongs_to :coordinator, class_name: "User"
  has_many :inventory_lines, as: :inventoried, dependent: :destroy
  has_many :product_assignments, as: :assigned, dependent: :destroy

  def to_s
    "#{name} (#{coordinator} - #{address&.administrative_area})"
  end
end
