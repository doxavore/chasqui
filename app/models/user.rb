# frozen_string_literal: true

class User < ApplicationRecord
  include Receipts::Participant
  include Taggable
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
  has_many :external_entity_users, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_many :external_entities, through: :external_entity_users
  accepts_nested_attributes_for :printers, allow_destroy: true
  accepts_nested_attributes_for :product_assignments, allow_destroy: true
  accepts_nested_attributes_for :address, allow_destroy: true

  has_many :inventory_lines, as: :inventoried, dependent: :destroy
  accepts_nested_attributes_for :inventory_lines, allow_destroy: true

  ransacker :has_printers do
    Arel.sql("(select exists (select 1 from printers where printers.user_id = users.id))")
  end

  attr_accessor :phone_confirmation, :email_confirmation, :number_of_printers, :printer_type, :work_area

  # validates :phone, presence: true, confirmation: true, length: { minimum: 9 }
  # validates :phone_confirmation, presence: true

  scope :printers, -> { where_assoc_exists(:printers) }
  scope :admins, -> { where(admin: true) }

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def to_s
    "#{first_name} #{last_name} #{email}"
  end
  alias name to_s

  def cp_coordinator?
    return @cp_coordinator if defined?(@cp_coordinator)

    @cp_coordinator ||= collection_points.any?
  end

  def marketing?
    return @marketing if defined?(@marketing)

    @marketing ||= tags.map(&:name).map(&:downcase).include?("marketing")
  end

  def logistics?
    return @logistics if defined?(@logistics)

    @logistics ||= tags.map(&:name).map(&:downcase).include?("logistica")
  end

  def planning?
    return @planning if defined?(@planning)

    @planning ||= tags.map(&:name).map(&:downcase).include?("plan")
  end

  def volunteer?
    cp_coordinator? || marketing? || logistics? || planning? || admin?
  end

  def concerned_records
    @concerned_records ||= external_entities + collection_points + overseen + [self]
  end

  def as_json(options = {})
    super(
      options.merge(methods: :name)
    )
  end
end
