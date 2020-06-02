# frozen_string_literal: true

class ReceiptPolicy < ApplicationPolicy
  def show?
    user.admin? || user.volunteer? || own_receipt?
  end

  def index?
    show?
  end

  def edit?
    return true if user.admin?

    if record.completed?
      user.cp_coordinator? || user.marketing? || user.logistics?
    else
      user.cp_coordinator? || user.logistics?
    end
  end

  def update?
    edit?
  end

  def begin_delivery?
    update?
  end

  def void?
    return user.admin? if record.completed?

    update?
  end

  def complete?
    update?
  end

  def own_receipt?
    (record.participants & user.concerned_records).any?
  end

  class Scope < Scope
    def resolve
      return scope if user.admin? || user.cp_coordinator? || user.marketing? || user.logistics?

      scope.where(origin: user).or(scope.where(destination: user))
    end
  end
end
