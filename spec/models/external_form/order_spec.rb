# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalForm::Order, type: :model do
  subject(:register) { described_class.new(params).register }

  let(:entity) { "Test" }
  let(:first_name) { "Bob" }
  let(:last_name) { "Jones" }
  let(:profession) { "Worker" }
  let(:phone) { "123123123" }
  let(:administrative_area) { "Foo" }
  let(:locality) { "locality" }
  let(:line_1) { "123 Street" }
  let(:line_2) { "Urbanization" }
  let(:ref) { "Corner of blar and street" }
  let(:orderable) { create(:product, orderable: true) }
  let(:product) { orderable.id }
  let(:quantity) { "10" }
  let(:email) { "bob.jones@email.com" }

  let(:params) do
    {
      entity: entity,
      first_name: first_name,
      last_name: last_name,
      profession: profession,
      phone: phone,
      phone_confirmation: phone,
      email: email,
      email_confirmation: email,
      administrative_area: administrative_area,
      locality: locality,
      line_1: line_1,
      line_2: line_2,
      ref: ref,
      product: product,
      quantity: quantity
    }
  end

  before do
    create(:user, admin: true)
  end

  it "creates an order" do
    expect { register }.to(change { ::Order.count })
  end

  it "adds a user to the external entity" do
    register
    expect(ExternalEntity.last.users.first.email).to eq(email)
  end

  it "adds the user to the order" do
    register
    expect(::Order.last.user.email).to eq(email)
  end
end
