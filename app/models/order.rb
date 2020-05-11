# frozen_string_literal: true

class Order < ApplicationRecord
  include AASM
  has_paper_trail
  belongs_to :external_entity
  belongs_to :collection_point, optional: true
  has_many :inventory_lines, as: :inventoried, dependent: :destroy
  accepts_nested_attributes_for :inventory_lines, allow_destroy: true
  after_save :check_collection_point_assignment

  aasm(column: "state") do
    state :pending_approval, initial: true
    state :pending_assignment
    state :assigned
    state :voided
    state :completed

    event :approve do
      transitions from: :pending_approval, to: :pending_assignment
    end

    event :assign do
      transitions from: :pending_assignment, to: :assigned, guard: :collection_point_assigned?
    end

    event :complete do
      transitions from: :assigned, to: :completed do
        guard do
          can_complete?
        end
      end
    end

    event :void do
      transitions from: %i[pending_approval pending_assignment assigned], to: :voided
    end
  end

  def can_complete?
    inventory_lines.inject(true) { |sum, l| sum && l.complete? }
  end

  def collection_point_assigned?
    collection_point.present?
  end

  def check_collection_point_assignment
    if pending_assignment? && collection_point.present?
      assign!
    end
  end
end
