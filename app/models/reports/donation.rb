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

      @products_donated = inventory_lines.each_with_object({}) do |line, hsh|
        hsh[line.product.name] ||= 0
        hsh[line.product.name] += line.quantity_present
      end.to_a
    end

    def entity_recipients
      return @entity_recipients if defined?(@entity_recipients)

      @entity_recipients = receipts.each_with_object({}) do |receipt, hsh|
        hsh[receipt.destination.to_s] ||= 0
        receipt.inventory_lines.each { |il| hsh[receipt.destination.to_s] += il.quantity_present }
      end.to_a
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

    def inventory_lines
      @inventory_lines = receipts&.map(&:inventory_lines)&.flatten || []
    end
  end
end
