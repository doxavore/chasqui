# frozen_string_literal: true

module ExternalForm
  class Order
    include ActiveModel::Model
    attr_accessor(
      :entity,
      :first_name,
      :last_name,
      :profession,
      :phone,
      :email,
      :administrative_area,
      :locality,
      :line_2,
      :line_1,
      :ref,
      :product,
      :quantity
    )

    validates :entity, presence: true
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :profession, presence: true
    validates :phone, presence: true, confirmation: true, length: { minimum: 9 }
    validates :phone_confirmation, presence: true
    validates :email_confirmation, presence: true
    validates :email, presence: true, confirmation: true
    validates :email, format: Devise.email_regexp
    validates :administrative_area, presence: true
    validates :locality, presence: true
    validates :line_1, presence: true
    validates :line_2, presence: true
    validates :ref, presence: true
    validates :product, presence: true
    validates :quantity, presence: true

    def register
      return unless valid?

      create_order!

      self
    end

    private

    def create_order!
      order = ::Order.new
      order.external_entity = external_entity
      order.save!
      InventoryLine.create!(
        inventoried: order,
        product_id: product.to_i,
        quantity_desired: quantity.to_i
      )
    end

    def external_entity
      return @external_entity if defined?(@external_entity)

      @external_entity = ExternalEntity.create!(name: entity, users: [user])
      create_address
      @external_entity
    end

    def create_address
      address = Address.create!(
        line_1: line_1,
        line_2: line_2,
        locality: locality,
        administrative_area: administrative_area,
        country: "PE",
        addressable: @external_entity
      )

      comm = ActiveAdmin::Comment.new
      comm.resource = address
      comm.body = "Referencia: #{ref}"
      comm.author = User.admins.first
      comm.namespace = "admin"
      comm.save!
    end

    def user
      return @user if defined?(@user)

      @user = User.find_by(email: email)
      return @user if @user

      pw = SecureRandom.uuid
      @user = User.create!(
        email: email.downcase.strip,
        first_name: first_name.titleize,
        last_name: last_name.titleize,
        phone: phone,
        password: pw,
        password_confirmation: pw,
        profession: profession
      )
    end
  end
end
