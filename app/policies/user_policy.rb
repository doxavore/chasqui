# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  ADMIN_ATTRIBUTES = %i[
    email
    password
    password_confirmation
    admin
    first_name
    last_name
    company
    phone
    address_id
    coordinator_id
    status
    profession
    printer_ids
    tag_ids
    printers_attributes
    address_attributes
    product_assignments_attributes
  ].freeze

  OWN_ATTRIBUTES = %i[
    password
    password_confirmation
    first_name
    last_name
    company
    phone
    address_id
    status
    profession
    printer_ids
    printers_attributes
    address_attributes
  ].freeze

  def permitted_attributes
    if user.admin?
      ADMIN_ATTRIBUTES
    elsif self?
      OWN_ATTRIBUTES
    else
      []
    end
  end

  def index?
    user.admin? || user.volunteer?
  end

  def show?
    self? || user.admin? || user.volunteer?
  end

  def update?
    self? || user.admin?
  end

  def edit?
    update?
  end

  def self?
    record.id == user.id
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
