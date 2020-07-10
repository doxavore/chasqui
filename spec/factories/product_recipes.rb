# frozen_string_literal: true

FactoryBot.define do
  factory :product_recipe do
    name { Faker::Hipster.unique.words(number: 2).join(" ") + " Recipe"}
    product { create(:product) }

    factory :recipe_with_ingredients do
      transient do
        ingredient_count { 3 }
      end

      after(:create) do |recipe, evaluator|
        create_list(:ingredient, evaluator.ingredient_count, product_recipe: recipe)
      end
    end

  end
end
