# frozen_string_literal: true

FactoryBot.define do
  factory :printer_model do
    name { Faker::Hipster.unique.words(number: 2).join(' ') }
    x_mm { 200 }
    y_mm { 200 }
    z_mm { 200 }
    petg { false }
    abs  { false }
  end
end
