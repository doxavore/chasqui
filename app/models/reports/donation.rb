# frozen_string_literal: true

module Reports
  class Donation < Base
    def receipts
      @receipts ||= Receipt.completed
                           .where(delivered_at: start_date..end_date)
                           .where(destination_type: "ExternalEntity")
                           .includes(destination: [:address], inventory_lines: [:product])
    end

    def products_donated
      return @products_donated if defined?(@products_donated)

      @products_donated = entity_recipients.values.each_with_object({}) do |line, hsh|
        line.each_pair do |key, val|
          hsh[key] ||= 0
          hsh[key] += val
        end
      end.to_a
    end

    def entity_recipients
      return @entity_recipients if defined?(@entity_recipients)

      @entity_recipients = receipts.map(&:destination).uniq.each_with_object({}) do |external_entity, hsh|
        hsh[external_entity.name] = recipient_donations(external_entity)
      end
    end

    def receipt_count
      @receipts.count
    end

    def to_h
      {
        products_donated: products_donated,
        entity_recipients: entity_recipients,
        receipt_count: receipt_count,
        start_date: start_date.to_date,
        end_date: end_date.to_date
      }
    end

    private

    def recipient_donations(external_entity)
      inv_map = raw_donated(external_entity)
      ProductRecipe.order(priority: :desc).find_each do |recipe|
        recipe.mutate_inv_map(inv_map)
      end

      pretty_map = {}
      inv_map.each_pair do |key, val|
        pretty_map[Product.find(key).name] = val if val.positive?
      end
      pretty_map
    end

    def raw_donated(external_entity)
      inventory_lines(external_entity).each_with_object({}) do |line, hsh|
        hsh[line.product_id] ||= 0
        hsh[line.product_id] += line.quantity_present
      end
    end

    def inventory_lines(external_entity)
      @inventory_lines = receipts&.where(destination: external_entity)&.map(&:inventory_lines)&.flatten || []
    end
  end
end
