# frozen_string_literal: true

class ExternalEntityUser < ApplicationRecord
  belongs_to :external_entity
  belongs_to :user
end
