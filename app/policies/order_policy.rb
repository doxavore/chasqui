# frozen_string_literal: true

class OrderPolicy < ApplicationPolicy
  def update?
    user.admin? || user.planning?
  end

  def new?
    update?
  end

  def create?
    update?
  end
end
