# frozen_string_literal: true

class CollectionPoint < ApplicationRecord
  belongs_to :address
  belongs_to :coordinator, class_name: "User"
end
