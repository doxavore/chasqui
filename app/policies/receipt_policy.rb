# frozen_string_literal: true

class ReceiptPolicy < ApplicationPolicy

  def show?
    user.admin? || user.cp_coordinator? || user.marketing? || user.own_receipt?
  end

  def index?
    show?
  end

  def update?
    user.admin? || user.cp_coordinator?
  end

  def begin_delivery?
    update?
  end

  def void?
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
      return scope if user.admin? || user.cp_coordinator? || user.marketing?
      scope.where(origin: user).or(scope.where(destination: user))
    end
  end
end
