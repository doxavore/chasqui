# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  context "when coordinating users" do
    subject!(:user) { create(:user, coordinator: coordinator) }

    let(:coordinator) { create(:user) }

    it "has one coordinator" do
      expect(user.coordinator).to eq(coordinator)
    end

    it "has overseen users" do
      expect(coordinator.overseen.first).to eq(user)
    end

    it "does not need a coordinator" do
      expect { user.update!(coordinator: nil) }.not_to raise_error
    end
  end

  context "when coordinating collection_points" do
    subject!(:coordinator) { create(:user) }

    let(:address) { create(:address) }
    let!(:collection_point) { create(:collection_point, coordinator: coordinator, address: address) }

    it "can have coordinated collection points" do
      expect(coordinator.collection_points.first).to eq(collection_point)
    end
  end
end
