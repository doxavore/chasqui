# frozen_string_literal: true

class UserPolicy < ApplicationPolicy

  def permitted_attributes
    if user.admin?
      %i[
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
      ]
    elsif self?
      %i[
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
      ]
    else
      []
    end
  end

  def show?
    self? || user.admin?
  end

  def update?
    self? || user.admin?
  end

  def edit?
    self? || user.admin?
  end

  def self?
    record.id == user.id
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    record.id == user.id || user.admin?
  end
end
