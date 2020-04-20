# frozen_string_literal: true

require "rails_helper"

RSpec.describe CollectionPoint, type: :model do
  subject(:collection_point) { create(:collection_point, coordinator: coordinator) }

  let!(:address) { create(:address, addressable: collection_point) }
  let!(:coordinator) { create(:user) }

  describe "#address" do
    it "has one address" do
      expect(collection_point.address).to eq(address)
    end
  end

  describe "#coordinator" do
    it "has one coordinator" do
      expect(collection_point.coordinator).to eq(coordinator)
    end

    it "must have a coordinator" do
      expect { collection_point.update!(coordinator: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
