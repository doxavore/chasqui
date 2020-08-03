# frozen_string_literal: true

module ExternalForm
  class BaseController < ApplicationController
    skip_before_action :authenticate_user!
    before_action :skip_authorization
    respond_to :html

    private

    def allow_iframe
      response.headers.delete "X-Frame-Options"
    end
  end
end
