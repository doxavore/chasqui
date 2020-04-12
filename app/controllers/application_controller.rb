# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationLocale
  include ApplicationViewLayout

  before_action :authenticate_user!
end
