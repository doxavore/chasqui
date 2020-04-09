# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("RAILS_EMAIL_FROM")
  layout "mailer"
end
