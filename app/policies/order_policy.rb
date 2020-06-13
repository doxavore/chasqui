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

  def approve?
    update?
  end

  def void?
    update?
  end

  def complete?
    update?
  end

  def uncomplete?
    update?
  end
end
