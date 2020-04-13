# frozen_string_literal: true

require "i18n"

module LocaleSpecHelper
  def self.included(base)
    base.extend(ExampleGroupMethods)
  end

  def with_locale(new_locale, &block)
    I18n.with_locale(new_locale, &block)
  end

  module ExampleGroupMethods
    def set_locale(new_locale) # rubocop:disable Naming/AccessorMethodName
      around do |example|
        with_locale(new_locale) { example.run }
      end
    end
  end
end
