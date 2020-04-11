# frozen_string_literal: true

module ApplicationLocale
  extend ActiveSupport::Concern

  included do
    prepend_before_action :switch_locale # around_actions are always run after all before_actions.
  end

  private

  def detect_locale
    cookies[:locale] ||
      request.env["HTTP_ACCEPT_LANGUAGE"].to_s.scan(/^[a-z]{2}/).first ||
      I18n.default_locale
  end

  def switch_locale
    cookies[:locale] = params[:locale] if params[:locale]

    I18n.locale = detect_locale
  end
end
