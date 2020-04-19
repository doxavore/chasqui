# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable

  belongs_to :address, optional: true
  has_many :printers, dependent: :destroy
  has_many :overseen, class_name: "User", foreign_key: "coordinator_id", dependent: :nullify, inverse_of: :coordinator
  belongs_to :coordinator, class_name: "User", optional: true
  belongs_to :address, optional: true
  has_many :collection_points, foreign_key: "coordinator_id", dependent: :nullify, inverse_of: :coordinator
  accepts_nested_attributes_for :printers, allow_destroy: true
  accepts_nested_attributes_for :address, allow_destroy: true

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def to_s
    "#{first_name} #{last_name} #{email}"
  end
end
