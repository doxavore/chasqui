# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    line_1              { Faker::Address.street_address }
    locality            { Faker::Address.city }
    administrative_area { Faker::Address.city }
    postal_code         { Faker::Address.postcode }
  end
end
