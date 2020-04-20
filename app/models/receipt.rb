# frozen_string_literal: true

class Receipt < ApplicationRecord
  has_many :inventory_lines, as: :inventoried, dependent: :destroy
  accepts_nested_attributes_for :inventory_lines, allow_destroy: true
  belongs_to :origin, polymorphic: true
  belongs_to :destination, polymorphic: true

  def self.participants
    User.printers + CollectionPoint.all + ExternalEntity.all
  end

  def origin_identifier
    return unless origin

    "#{origin.class}-#{origin.id}"
  end

  def origin_identifier=(origin_data)
    return if origin_data.blank?

    origin_data = origin_data.split("-")
    self.origin_type = origin_data[0]
    self.origin_id = origin_data[1]
  end

  def destination_identifier
    return unless destination

    "#{destination.class}-#{destination.id}"
  end

  def destination_identifier=(destination_data)
    return if destination_data.blank?

    destination_data = destination_data.split("-")
    self.destination_type = destination_data[0]
    self.destination_id = destination_data[1]
  end
end
