# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable

  has_many :printers
  has_many :overseen, class_name: "User", foreign_key: "coordinator_id"
  belongs_to :coordinator, class_name: "User", optional: true
  has_many :collection_points, foreign_key: "coordinator_id"

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
