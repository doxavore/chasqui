# frozen_string_literal: true

module ExternalForm
  class BaseController < ApplicationController
    skip_before_action :authenticate_user!
    respond_to :html
  end
end
