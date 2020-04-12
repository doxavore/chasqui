# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user, coordinator: coordinator) }
  let!(:coordinator) { create(:user) }

  it 'can belong to a coordinator' do
    expect(user.coordinator.id).to eq(coordinator.id)
  end

  it 'can have overseen users' do
    expect(coordinator.overseen.count).to eq(1)
  end
end
