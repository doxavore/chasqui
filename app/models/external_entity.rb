# frozen_string_literal: true

class ExternalEntity < ApplicationRecord
  has_many :orders, dependent: :destroy
  belongs_to :user
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true

  def to_s
    "#{name} (#{address&.administrative_area})"
  end
end
