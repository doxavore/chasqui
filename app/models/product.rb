# frozen_string_literal: true

class Product < ApplicationRecord
  scope :producible, -> { where(producible: true) }
  scope :orderable, -> { where(orderable: true) }
  has_many :inventory_lines, dependent: :destroy
  has_many :product_providers, dependent: :destroy
  has_many :external_entities, through: :product_providers
  accepts_nested_attributes_for :product_providers, allow_destroy: true
  has_many :product_recipes, dependent: :destroy

  def credit_to_line(inventory_line, inv_map)
    if product_recipes.any?
      product_recipes.each { |r| r.credit_to_line(inventory_line, inv_map) }
    elsif inv_map.key?(id)
      credit_quantity = [inventory_line.quantity_remaining, inv_map[id]].min
      inv_map[id] -= credit_quantity
      inventory_line.quantity_present += credit_quantity
      inventory_line.save!
    end
  end

  def debit_from_line(inventory_line, inv_map)
    if product_recipes.any?
      product_recipes.each { |r| r.debit_from_line(inventory_line, inv_map) }
    elsif inv_map.key?(id)
      debit_quantity = [inventory_line.quantity_present, inv_map[id]].min
      inv_map[id] -= debit_quantity
      inventory_line.quantity_present -= debit_quantity
      inventory_line.save!
    end
  end
end
