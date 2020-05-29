# frozen_string_literal: true

require "resque/server"

Rails.application.routes.draw do
  devise_for :users

  ActiveAdmin.routes(self)

  root to: "admin/dashboard#index"

  authenticate :user, lambda { |user| user.admin? } do
    mount Resque::Server, at: "/admin/resque"
  end

  get "dokku/deploy_check", to: "dokku#deploy_check"
end
