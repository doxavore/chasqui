# frozen_string_literal: true

class ReceiptPolicy < ApplicationPolicy

  def show?
    user.admin? || record.origin == user || record.destination == user
  end

  def index?
    user
  end

  class Scope < Scope
    def resolve
      scope.where(origin: user).or(scope.where(destination: user))
    end
  end

  def update?
    user.admin?
  end
end
