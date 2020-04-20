# frozen_string_literal: true

class ProductAssignment < ApplicationRecord
  belongs_to :assigned, polymorphic: true
  belongs_to :product

  validates :assigned, presence: true
  validates :product, presence: true
  validates :product_id, uniqueness: { scope: %i[assigned_type assigned_id] }

  def assigned_identifier
    "#{assigned.class}-#{assigned.id}"
  end

  def assigned_identifier=(assigned_data)
    return if assigned_data.blank?

    assigned_data = assigned_data.split("-")
    self.assigned_type = assigned_data[0]
    self.assigned_id = assigned_data[1]
  end
end
