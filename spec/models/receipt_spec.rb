# frozen_string_literal: true

require "rails_helper"

RSpec.describe Receipt, type: :model do
  let(:ee) { create(:external_entity) }

  let(:coordinator) { create(:user) }
  let(:collection_point) { create(:collection_point, coordinator: coordinator) }

  describe "when transferring from external_entity to collection_point" do
    let(:receipt) { create(:complete_receipt, origin: ee, destination: collection_point, state: :delivering) }

    it "creates a new line for each missing product" do
      receipt.complete
      expect(collection_point.inventory_lines.count).to eq(3)
    end

    it "sets the right quantities" do
      receipt.complete
      collection_point.inventory_lines.each do |inv_line|
        receipt_line = receipt.inventory_lines.find_by(product: inv_line.product)
        expect(receipt_line.quantity_present).to eq(inv_line.quantity_present)
      end
    end
  end

  describe "when transferring from collection_point to external_entity " do
    let(:receipt) { create(:complete_receipt, origin: collection_point, destination: ee, state: :delivering) }

    it "creates a new line for each missing product on the collection_point" do
      receipt.complete
      expect(collection_point.inventory_lines.count).to eq(3)
    end

    it "sets the right quantities" do
      receipt.complete
      collection_point.inventory_lines.each do |inv_line|
        receipt_line = receipt.inventory_lines.find_by(product: inv_line.product)
        expect(receipt_line.quantity_present).to eq(0 - inv_line.quantity_present)
      end
    end

    describe "when the external_entity has an order" do
      let!(:order) do
        new_order = create(:order, external_entity: ee, state: :assigned)
        receipt.inventory_lines.each do |receipt_line|
          create(
            :inventory_line,
            inventoried: new_order,
            product: receipt_line.product,
            quantity_desired: receipt_line.quantity_present
          )
        end

        new_order
      end

      it "fulfills the order lines" do
        receipt.complete
        order.inventory_lines.each do |inv_line|
          expect(inv_line.quantity_remaining).to eq(0)
        end
      end

      it "marks the order as complete" do
        receipt.complete
        expect(order.reload.state).to eq("completed")
      end
    end
  end

  describe "when transferring from collection_point to user" do
    let(:user) { create(:user) }
    let(:receipt) { create(:complete_receipt, origin: collection_point, destination: user, state: :delivering) }

    before do
      receipt.inventory_lines.each do |receipt_line|
        create(
          :inventory_line,
          inventoried: collection_point,
          product: receipt_line.product,
          quantity_present: receipt_line.quantity_present * 2
        )
      end
    end

    it "creates a new line for each missing product" do
      receipt.complete
      expect(user.inventory_lines.count).to eq(3)
    end

    it "sets the right quantities on the user" do
      receipt.complete
      user.inventory_lines.each do |inv_line|
        receipt_line = receipt.inventory_lines.find_by(product: inv_line.product)
        expect(receipt_line.quantity_present).to eq(inv_line.quantity_present)
      end
    end

    it "debits the right quantities from the collection_point" do
      receipt.complete
      collection_point.inventory_lines.each do |inv_line|
        receipt_line = receipt.inventory_lines.find_by(product: inv_line.product)
        expect(receipt_line.quantity_present).to eq(inv_line.quantity_present)
      end
    end
  end
end
