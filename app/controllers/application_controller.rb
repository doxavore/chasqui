# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationLocale
  include ApplicationViewLayout

  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit

  def user_for_paper_trail
    current_user
  end
end
