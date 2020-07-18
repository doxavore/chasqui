# frozen_string_literal: true

module Reports
  class Orders < Base
    def orders
      @orders ||= Order.where.not(state: :voided).includes(:external_entity, inventory_lines: :product)
    end

    def material_ordered
      inventory_lines.each_with_object({}) do |line, hsh|
        hsh[line.product_id] ||= {}
        hsh[line.product_id][:name] = line.product.name
        hsh[line.product_id][:desired] ||= 0
        hsh[line.product_id][:desired] += line.quantity_desired
        hsh[line.product_id][:present] ||= 0
        hsh[line.product_id][:present] += line.quantity_present
      end
    end

    def summary
      {
        pending_approval: orders.where(state: :pending_approval).count,
        pending_assignment: orders.where(state: :pending_assignment).count,
        assigned: orders.where(state: :assigned).count,
        completed: orders.where(state: :completed).count,
        total: orders.count
      }
    end

    def to_h
      {
        summary: summary,
        material_ordered: material_ordered,
        start_date: start_date.to_date,
        end_date: end_date.to_date
      }
    end

    private

    def inventory_lines
      @inventory_lines = orders&.map(&:inventory_lines)&.flatten || []
    end
  end
end
