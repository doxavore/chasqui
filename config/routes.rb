# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: "home#show"

  get "dokku/deploy_check", to: "dokku#deploy_check"
end
