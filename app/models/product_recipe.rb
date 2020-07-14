# frozen_string_literal: true

class ProductRecipe < ApplicationRecord
  belongs_to :product
  has_many :ingredients, dependent: :destroy
  accepts_nested_attributes_for :ingredients, allow_destroy: true

  def credit_to_line(inventory_line, inv_map)
    max_quantity = find_max_quantity(inv_map)

    return unless max_quantity.positive?

    ingredients.each do |ingredient|
      inv_map[ingredient.product_id] -= max_quantity * ingredient.quantity
    end

    inventory_line.quantity_present += max_quantity
    inventory_line.save!
  end

  def debit_from_line(inventory_line, inv_map)
    max_quantity = [find_max_quantity(inv_map), inventory_line.quantity_present].min

    return unless max_quantity.positive?

    ingredients.each do |ingredient|
      inv_map[ingredient.product_id] -= max_quantity * ingredient.quantity
    end

    inventory_line.quantity_present -= max_quantity
    inventory_line.save!
  end

  private

  def find_max_quantity(inv_map)
    max_quantity = 0
    ingredients.each do |ingredient|
      break unless inv_map.key?(ingredient.product_id)

      available = inv_map[ingredient.product_id].to_i
      break unless available.positive?
      max_quantity = (available - (available % ingredient.quantity)) / ingredient.quantity
      break unless max_quantity.positive?
    end

    max_quantity
  end
end
