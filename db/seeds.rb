# frozen_string_literal: true


admin_user = User.create!(
  email: "admin@example.com",
  password: "admintest",
  password_confirmation: "admintest",
  admin: true
)

admin_address = Address.create!(
    addressable: admin_user,
    line_1: "Pasaje Moquegua, 203",
    line_2: "Urb. San Felipe",
    locality: "Comas",
    administrative_area: "Lima",
    country: "PE"
)

Product.create!(name: "Visera PM", producible: true)
Product.create!(name: "PLA 1kg")
Product.create!(name: "ABS 1kg")
Product.create!(name: "PETG 1kg")
