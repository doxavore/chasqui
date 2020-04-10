# frozen_string_literal: true

class DokkuController < ApplicationController
  skip_before_action :authenticate_user!

  def deploy_check
    ActiveRecord::Base.connection.active? || raise("Postgres connection failed")

    Resque.redis.server_time || raise("Redis connection failed")

    render plain: "deploy_ok"
  end
end
