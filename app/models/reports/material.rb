# frozen_string_literal: true

module Reports
  class Material < Base
    def receipts
      @receipts ||= Receipt.completed
                           .where(delivered_at: start_date..end_date)
                           .where(destination_type: "User")
                           .where(origin_type: "CollectionPoint")
                           .includes(destination: [:address], inventory_lines: [:product])
    end

    def material_delivered
      return @material_delivered if defined?(@material_delivered)

      @material_delivered = inventory_lines.each_with_object({}) do |line, hsh|
        hsh[line.product.name] ||= 0
        hsh[line.product.name] += line.quantity_present
      end.to_a
    end

    def recipients
      return @recipients if defined?(@recipients)

      @precipients = receipts.each_with_object({}) do |receipt, hsh|
        user = receipt.destination.to_s
        hsh[user] ||= 0
        receipt.inventory_lines.each { |il| hsh[user] += il.quantity_present }
      end.to_a
    end

    def collection_points
      return @collection_points if defined?(@collection_points)

      @collection_points = receipts.each_with_object({}) do |receipt, hsh|
        cp = receipt.origin.to_s
        hsh[cp] ||= 0
        receipt.inventory_lines.each { |il| hsh[cp] += il.quantity_present }
      end.to_a
    end

    def receipt_count
      @receipts.count
    end

    def to_h
      {
        material_delivered: material_delivered,
        recipients: recipients,
        collection_points: collection_points,
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
