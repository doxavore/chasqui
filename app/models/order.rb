# frozen_string_literal: true

class Order < ApplicationRecord
  include AASM
  include Taggable
  has_paper_trail
  belongs_to :external_entity
  has_one :address, through: :external_entity
  belongs_to :collection_point, optional: true
  belongs_to :user, optional: true
  has_many :inventory_lines, as: :inventoried, dependent: :destroy
  accepts_nested_attributes_for :inventory_lines, allow_destroy: true
  after_save :check_collection_point_assignment

  scope :active, -> { where.not(state: :voided) }
  scope :voided, -> { where(state: :voided) }

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

    event :uncomplete do
      transitions from: :completed, to: :assigned
    end

    event :void do
      transitions from: %i[pending_approval pending_assignment assigned], to: :voided
    end
  end

  def self.reconcile
    orders = all.includes(external_entity: :destination_receipts)
    receipts = orders.map(&:external_entity).uniq.map(&:destination_receipts).flatten
    receipts.each do |receipt|
      next unless receipt.completed?

      ActiveRecord::Base.transaction do
        receipt.revert_inventories
        receipt.update_inventories
      end
    end
  end

  def can_complete?
    inventory_lines.inject(true) { |sum, l| sum && l.complete? }
  end

  def collection_point_assigned?
    collection_point.present?
  end

  def check_collection_point_assignment
    assign! if pending_assignment? && collection_point.present?
  end
end
