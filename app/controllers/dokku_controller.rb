class DokkuController < ApplicationController
  def deploy_check
    render plain: "deploy_ok"
  end
end
