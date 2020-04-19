# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  ActiveAdmin.routes(self)
  root to: "admin/dashboard#index"

  get "dokku/deploy_check", to: "dokku#deploy_check"
end
