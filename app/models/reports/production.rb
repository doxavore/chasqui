# frozen_string_literal: true

module Reports
  class Production < Base
    def receipts
      @receipts ||= Receipt.completed
                           .where(delivered_at: start_date..end_date)
                           .where(destination_type: "CollectionPoint")
                           .where(origin_type: "User")
                           .includes(destination: [:address], inventory_lines: [:product])
    end

    def products_produced
      return @products_produced if defined?(@products_produced)

      @products_produced = inventory_lines.each_with_object({}) do |line, hsh|
        hsh[line.product.name] ||= 0
        hsh[line.product.name] += line.quantity_present if line.product.producible?
      end.to_a
    end

    def producers
      return @producers if defined?(@producers)

      @producers = receipts.each_with_object({}) do |receipt, hsh|
        user = receipt.origin.to_s
        hsh[user] ||= 0
        receipt.inventory_lines.each { |il| hsh[user] += il.quantity_present if il.product.producible? }
      end.to_a
    end

    def receipt_count
      @receipts.count
    end

    def to_h
      {
        products_produced: products_produced,
        producers: producers,
        receipt_count: receipt_count,
        start_date: start_date.to_date,
        end_date: end_date.to_date
      }
    end

    private

    def inventory_lines
      @inventory_lines = receipts&.map(&:inventory_lines)&.flatten || []
    end
  end
end
