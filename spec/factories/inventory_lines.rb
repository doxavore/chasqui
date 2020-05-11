# frozen_string_literal: true

FactoryBot.define do
  factory :inventory_line do
    trait :with_product do
      product { create(:product) }
    end

    factory :inventory_line_with_product, traits: [:with_product]
  end
end
