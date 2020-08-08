# frozen_string_literal: true

class HomeController < ApplicationController
  def show; end

  def error
    raise "blar"
  end
end
