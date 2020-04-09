# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale

  private

  def switch_locale(&action)
    locale = params[:locale] || request.env["HTTP_ACCEPT_LANGUAGE"].to_s.scan(/^[a-z]{2}/).first || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
