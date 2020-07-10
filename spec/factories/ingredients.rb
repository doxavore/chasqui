# frozen_string_literal: true

FactoryBot.define do
  factory :ingredient do
    product { create(:product) }
    quantity { 2 }
  end
end
