# frozen_string_literal: true

class ExternalEntityPolicy < ApplicationPolicy
  def update?
    user.admin? || user.planning? || user.logistics?
  end

  def new?
    update?
  end

  def create?
    update?
  end
end
