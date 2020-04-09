# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale

  private

  def detect_locale
    cookies[:locale] ||
      request.env["HTTP_ACCEPT_LANGUAGE"].to_s.scan(/^[a-z]{2}/).first ||
      I18n.default_locale
  end

  def switch_locale(&action)
    cookies[:locale] = params[:locale] if params[:locale]
    locale = detect_locale
    I18n.with_locale(locale, &action)
  end
end
