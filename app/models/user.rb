# frozen_string_literal: true

class User < ApplicationRecord
  include Receipts::Participant
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable, :registerable

  has_many :printers, dependent: :destroy
  has_many :overseen, class_name: "User", foreign_key: "coordinator_id", dependent: :nullify, inverse_of: :coordinator
  belongs_to :coordinator, class_name: "User", optional: true
  has_many :collection_points, foreign_key: "coordinator_id", dependent: :nullify, inverse_of: :coordinator
  has_many :product_assignments, as: :assigned, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy
  has_many :origin_receipts, as: :origin, class_name: "Receipt", dependent: :nullify
  has_many :destination_receipts, as: :destination, class_name: "Receipt", dependent: :nullify
  accepts_nested_attributes_for :printers, allow_destroy: true
  accepts_nested_attributes_for :product_assignments, allow_destroy: true
  accepts_nested_attributes_for :address, allow_destroy: true

  has_many :inventory_lines, as: :inventoried, dependent: :destroy
  accepts_nested_attributes_for :inventory_lines, allow_destroy: true

  scope :printers, -> { where_assoc_exists(:printers) }

  # def send_devise_notification(notification, *args)
  #   devise_mailer.send(notification, self, *args).deliver_later
  # end

  def to_s
    "#{first_name} #{last_name} #{email}"
  end
end
