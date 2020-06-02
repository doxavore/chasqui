# frozen_string_literal: true

class CollectionPointPolicy < ApplicationPolicy
  def show?
    user.admin? || user.cp_coordinator? || user.marketing?
  end

  def index?
    show?
  end

  def update?
    user.admin? || record.coordinator == user
  end

  def edit?
    update?
  end

  class Scope < Scope
    def resolve
      return scope if user.admin? || user.cp_coordinator? || user.marketing?
      scope.none
    end
  end
end
