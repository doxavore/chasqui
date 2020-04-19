# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email                 { Faker::Internet.unique.email }
    confirmed_at          { Time.current }
    password              { Faker::Internet.password(min_length: 8, max_length: 128) }
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
