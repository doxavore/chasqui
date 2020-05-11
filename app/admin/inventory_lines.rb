# frozen_string_literal: true

ActiveAdmin.register InventoryLine do
  menu false
  belongs_to :collection_point, polymorphic: true, optional: true
end
