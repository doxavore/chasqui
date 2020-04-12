# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email                 { Faker::Internet.unique.email }
    confirmed_at          { Time.current }
    password              { Faker::Hipster.words(number: 2).join('') }
    password_confirmation { password }

    after :build do |user|
      user.skip_confirmation!
      user.skip_confirmation_notification!
    end

    after :create do |user|
      user.skip_confirmation!
      user.skip_confirmation_notification!
    end
  end
end
