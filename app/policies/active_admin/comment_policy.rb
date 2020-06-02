# frozen_string_literal: true

module ActiveAdmin
  class CommentPolicy < ::ApplicationPolicy
    def update?
      user.volunteer?
    end

    def new?
      update?
    end

    def create?
      update?
    end
  end
end
