# frozen_string_literal: true

admin_address = Address.create!(
    line_1: "Pasaje Moquegua, 203",
    line_2: "Urb. San Felipe",
    locality: "Comas",
    administrative_area: "Lima",
    country: "PE"
)

admin_user = User.create!(
  email: "admin@example.com",
  password: "admintest",
  password_confirmation: "admintest",
  address: admin_address,
  admin: true
)
