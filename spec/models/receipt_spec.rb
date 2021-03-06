# frozen_string_literal: true

require "rails_helper"

RSpec.describe Receipt, type: :model do
  let(:ee) { create(:external_entity) }
  let(:coordinator) { create(:user) }
  let(:collection_point) { create(:collection_point, coordinator: coordinator) }

  before do
    allow_any_instance_of(described_class).to receive(:image?).and_return(true) # rubocop:disable RSpec/AnyInstance
  end

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

    describe "when the order is a mixed bag" do
      let(:recipe) { create(:recipe_with_ingredients) }
      let(:unrelated_product) { create(:product) }

      let!(:order) do
        new_order = create(:order, external_entity: ee, state: :assigned)
        create(
          :inventory_line,
          inventoried: new_order,
          product: recipe.product,
          quantity_desired: 2
        )
        create(
          :inventory_line,
          inventoried: new_order,
          product: recipe.ingredients.first.product,
          quantity_desired: 2
        )

        create(
          :inventory_line,
          inventoried: new_order,
          product: unrelated_product,
          quantity_desired: 2
        )
        new_order
      end

      let(:receipt) do
        new_receipt = create(:receipt, origin: collection_point, destination: ee, state: :delivering)
        recipe.ingredients.each do |ing|
          create(
            :inventory_line,
            inventoried: new_receipt,
            quantity_present: 2 * ing.quantity,
            product: ing.product
          )
        end

        create(
          :inventory_line,
          inventoried: new_receipt,
          product: unrelated_product,
          quantity_present: 1
        )
        new_receipt
      end

      it "fulfills recipe products" do
        receipt.complete
        expect(order.reload.inventory_lines.where(product: recipe.product).first.quantity_present).to eq(2)
      end

      it "fulfills non-recipe products" do
        receipt.complete
        expect(order.reload.inventory_lines.where(product: unrelated_product).first.quantity_present).to eq(1)
      end

      it "prioritizes fulfilling recipe products" do
        receipt.complete
        ingredient_fulfilled = order.reload.inventory_lines
                                    .where(product: recipe.ingredients.first.product)
                                    .first.quantity_present
        expect(ingredient_fulfilled).to eq(0)
      end

      it "debits ingredients from the origin" do
        receipt.complete
        recipe.ingredients.each do |ing|
          expect(collection_point.reload.inventory_lines.find_by(product: ing.product).quantity_present)
            .to eq(-2 * ing.quantity)
        end
      end
    end

    describe "when voiding a completed receipt" do
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

      before do
        receipt.complete!
      end

      it "puts the order quantites back into collection_point inventory" do
        receipt.void!
        collection_point.inventory_lines.reload.each do |inv_line|
          expect(inv_line.quantity_present).to eq(0)
        end
      end

      it "unmarks the order as completed" do
        receipt.void!
        expect(order.reload.assigned?).to eq(true)
      end

      it "debits the quantities from the order" do
        receipt.void!
        order.inventory_lines.reload.each do |inv_line|
          expect(inv_line.quantity_present).to eq(0)
        end
      end
    end

    describe "when voiding a completed recipe order" do
      let(:recipe) { create(:recipe_with_ingredients) }
      let(:unrelated_product) { create(:product) }

      let!(:order) do
        new_order = create(:order, external_entity: ee, state: :assigned)
        create(
          :inventory_line,
          inventoried: new_order,
          product: recipe.product,
          quantity_desired: 2
        )
        create(
          :inventory_line,
          inventoried: new_order,
          product: recipe.ingredients.first.product,
          quantity_desired: 2
        )

        create(
          :inventory_line,
          inventoried: new_order,
          product: unrelated_product,
          quantity_desired: 2
        )
        new_order
      end

      let(:receipt) do
        new_receipt = create(:receipt, origin: collection_point, destination: ee, state: :delivering)
        recipe.ingredients.each do |ing|
          create(
            :inventory_line,
            inventoried: new_receipt,
            quantity_present: 2 * ing.quantity,
            product: ing.product
          )
        end

        create(
          :inventory_line,
          inventoried: new_receipt,
          product: unrelated_product,
          quantity_present: 1
        )
        new_receipt
      end

      before do
        receipt.complete!
      end

      it "puts the order quantites back into collection_point inventory" do
        receipt.void!
        collection_point.inventory_lines.reload.each do |inv_line|
          expect(inv_line.quantity_present).to eq(0)
        end
      end

      it "unmarks the order as completed" do
        receipt.void!
        expect(order.reload.assigned?).to eq(true)
      end

      it "debits the quantities from the order" do
        receipt.void!
        order.inventory_lines.reload.each do |inv_line|
          expect(inv_line.quantity_present).to eq(0)
        end
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

    it "sets the delivery date" do
      receipt.complete!
      expect(receipt.reload.delivered_at).not_to be_nil
    end
  end
end
