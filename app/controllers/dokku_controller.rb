# frozen_string_literal: true

class DokkuController < ApplicationController
  skip_before_action :authenticate_user!

  def deploy_check
    ActiveRecord::Base.connection.active?

    Resque.redis.server_time

    render plain: "deploy_ok"
  end
end
