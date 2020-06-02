# frozen_string_literal: true

class PrinterModelPolicy < ApplicationPolicy
  def update?
    user.admin?
  end

  def new?
    update?
  end

  def create?
    update?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
