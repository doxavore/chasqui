# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectionPoint, type: :model do
  let(:coordinator) { create(:user) }
  let(:address) { create(:address) }
  subject { create(:collection_point, coordinator: coordinator, address: address) }

  it "can belong to a coordinator" do
    expect(subject.coordinator.id).to eq(coordinator.id)
  end

  it "can belong to an address" do
    expect(subject.address.id).to eq(address.id)
  end
end
