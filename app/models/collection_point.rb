# frozen_string_literal: true

class CollectionPoint < ApplicationRecord
  include Receipts::Participant
  include Taggable
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true
  has_many :orders, dependent: :nullify
  has_many :inventory_lines, as: :inventoried, dependent: :destroy
  accepts_nested_attributes_for :inventory_lines, allow_destroy: true

  belongs_to :coordinator, class_name: "User"
  has_many :product_assignments, as: :assigned, dependent: :destroy
  has_many :origin_receipts, as: :origin, class_name: "Receipt", dependent: :nullify
  has_many :destination_receipts, as: :destination, class_name: "Receipt", dependent: :nullify

  def to_s
    "#{name} (#{coordinator} - #{address&.administrative_area})"
  end
end
