# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable

  belongs_to :address, optional: true
  has_many :printers, dependent: :destroy
  has_many :overseen, class_name: "User", foreign_key: "coordinator_id", dependent: :nullify, inverse_of: :coordinator
  belongs_to :coordinator, class_name: "User", optional: true
  has_many :collection_points, foreign_key: "coordinator_id", dependent: :nullify, inverse_of: :coordinator

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
