# frozen_string_literal: true

module ActiveAdmin
  class PagePolicy < ::ApplicationPolicy
    def show?
      true
    end

    def index?
      true
    end
  end
end
