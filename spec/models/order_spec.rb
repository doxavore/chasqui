# frozen_string_literal: true

require "rails_helper"

RSpec.describe Order, type: :model do
  let(:ee) { create(:external_entity) }
  let(:coordinator) { create(:user) }
  let(:collection_point) { create(:collection_point, coordinator: coordinator) }

  before do
    allow_any_instance_of(Receipt).to receive(:image?).and_return(true) # rubocop:disable RSpec/AnyInstance
  end

  describe "reconciling orders" do
    let(:recipe) { create(:recipe_with_ingredients) }
    let(:unrelated_product) { create(:product) }

    let(:order) do
      new_order = create(:order, external_entity: ee, state: :assigned)
      create(
        :inventory_line,
        inventoried: new_order,
        product: recipe.product,
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
      order
    end

    it "fulfills recipe products" do
      described_class.reconcile
      expect(order.reload.inventory_lines.where(product: recipe.product).first.quantity_present).to eq(2)
    end
  end
end
