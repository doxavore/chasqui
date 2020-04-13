# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  let(:coordinator) { create(:user) }

  context "when coordinating users" do
    let!(:user) { create(:user, coordinator: coordinator) }

    it "can belong to a coordinator" do
      expect(user.coordinator.id).to eq(coordinator.id)
    end

    it "can have overseen users" do
      expect(coordinator.overseen.first).to eq(user)
    end
  end

  context "when coordinating collection_points" do
    let(:address) { create(:address) }
    let!(:collection_point) { create(:collection_point, coordinator: coordinator, address: address) }

    it "can have coordinated collection points" do
      expect(coordinator.collection_points.first).to eq(collection_point)
    end
  end
end
