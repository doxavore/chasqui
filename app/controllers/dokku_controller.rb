# frozen_string_literal: true

class DokkuController < ApplicationController
  def deploy_check
    render plain: "deploy_ok"
  end
end
