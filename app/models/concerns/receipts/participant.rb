# frozen_string_literal: true

module Receipts::Participant
  def credit_receipt(receipt)
    apply_receipt(receipt) do |inv_line, receipt_line|
      inv_line.quantity_present += receipt_line.quantity_present
    end
  end

  def debit_receipt(receipt)
    apply_receipt(receipt) do |inv_line, receipt_line|
      inv_line.quantity_present -= receipt_line.quantity_present
    end
  end

  private

  def apply_receipt(receipt)
    receipt.inventory_lines.each do |receipt_line|
      inv_line = inventory_lines.find_or_create_by(product: receipt_line.product)
      yield(inv_line, receipt_line)
      inv_line.save
    end
  end
end
