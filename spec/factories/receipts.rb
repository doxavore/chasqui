# frozen_string_literal: true

FactoryBot.define do
  factory :receipt do
    trait :with_lines do
      transient do
        lines_count { 3 }
        quantity_present { 10 }
      end

      after(:create) do |receipt, evaluator|
        create_list(
          :inventory_line_with_product,
          evaluator.lines_count,
          inventoried: receipt,
          quantity_present: evaluator.quantity_present
        )
      end
    end

    factory :complete_receipt, traits: [:with_lines]
  end
end
