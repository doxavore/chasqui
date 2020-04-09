# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "home#show"

  get "dokku/deploy_check", to: "dokku#deploy_check"
end
