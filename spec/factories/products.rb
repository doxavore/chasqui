# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { Faker::Hipster.unique.words(number: 2).join(" ") }
  end
end
