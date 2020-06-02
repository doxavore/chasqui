# frozen_string_literal: true

class CollectionPointPolicy < ApplicationPolicy
  def update?
    user.admin? || record.coordinator == user || user.logistics?
  end

  def edit?
    update?
  end
end
