# frozen_string_literal: true

class Receipt < ApplicationRecord
  include AASM
  has_paper_trail
  has_many :inventory_lines, as: :inventoried, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :inventory_lines, allow_destroy: true
  belongs_to :origin, polymorphic: true
  belongs_to :destination, polymorphic: true
  has_one_attached :image

  aasm(column: "state") do
    state :draft, initial: true
    state :completed
    state :delivering
    state :voided

    event :begin_delivery do
      transitions from: :draft, to: :delivering
    end

    event :void do
      transitions from: %i[draft delivering], to: :voided
    end

    event :complete do
      before do
        update_inventories
      end
      transitions from: :delivering, to: :completed, guard: :has_image?
    end
  end

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

  def update_inventories
    origin.debit_receipt(self) if origin.respond_to?(:debit_receipt)
    destination.credit_receipt(self)
  end

  def to_h
    {
      state: state,
      origin: origin.to_s,
      destination: destination.to_s,
      inventory_lines: inventory_lines.map(&:to_h)
    }
  end

  def has_image?
    image.present?
  end
end
