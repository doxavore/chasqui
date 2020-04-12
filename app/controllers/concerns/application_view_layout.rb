# frozen_string_literal: true

module ApplicationViewLayout
  extend ActiveSupport::Concern

  included do
    layout :layout_by_resource
  end

  private

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end
end
