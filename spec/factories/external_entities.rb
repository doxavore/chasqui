# frozen_string_literal: true

FactoryBot.define do
  factory :external_entity do
    name { Faker::Hipster.unique.words(number: 2).join(" ") }
    user { create(:user) }
  end
end
