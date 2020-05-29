# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationLocale
  include ApplicationViewLayout
  include Pundit

  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit

  after_action :verify_authorized, except: :index, unless: :active_admin_controller?
  after_action :verify_policy_scoped, only: :index, unless: :active_admin_controller?

  def active_admin_controller?
    is_a?(ActiveAdmin::BaseController)
  end

  def user_for_paper_trail
    current_user
  end
end
