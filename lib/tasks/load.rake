# frozen_string_literal: true
# rubocop:disable all
namespace :load do

  task :orders do
    Rake::Task['environment'].invoke
    arr = CSV.read("#{Rails.root}/lib/tasks/solicitudes.csv")
    arr.each do |row|
      load_order_row(row)
    end

  end

  task :clean_users do
    Rake::Task['environment'].invoke
    User.find_each do |user|
      if user.last_name&.include?('[')
        user.first_name = user.first_name&.titleize
        user.last_name = JSON.parse(user.last_name).join(' ').titleize
        user.save!
      end
    end

    Address.find_each do |address|
      address.line_1 = address.line_1&.titleize
      address.line_2 = address.line_2&.titleize
      address.administrative_area = address.administrative_area&.titleize
      address.locality = address.locality&.titleize
      address.save!
    end

    ExternalEntity.find_each do |entity|
      entity.name = entity.name.titleize
      entity.save
    end
  end

  task :makers do
    Rake::Task['environment'].invoke
    arr = CSV.read("#{Rails.root}/lib/tasks/makers.csv")
    arr.each do |row|
      ActiveRecord::Base.transaction(requires_new: true) do
        load_maker(row)
      end
    end
  end

  def load_maker(row)
    email = row[9].to_s.downcase.strip

    return unless email.length > 5

    return if User.where(email: email).any?
    user = User.create!(
      email: email,
      first_name: row[7].split(' ')[0].titleize,
      last_name: row[7].split(' ')[1..].join(' ').titleize,
      phone: row[10],
      password: row[10].to_s + row[9].to_s,
      password_confirmation: row[10].to_s + row[9].to_s,
      status: row[2]&.titleize,
      profession: row[8]&.capitalize
    )

    Address.create!(
      addressable: user,
      line_1: row[5]&.titleize,
      line_2: row[6]&.titleize,
      administrative_area: row[2]&.titleize,
      locality: row[4]&.titleize
    )

    printer_count = row[12].to_i
    if printer_count.positive?
      printer_count.times do
        Printer.create!(
          name: row[11]&.capitalize,
          user: user,
          printer_model: PrinterModel.first
        )
      end
    end

    if row[15].present?
        comm = ActiveAdmin::Comment.new
      comm.resource = user
      comm.body = row[15]
      comm.author = User.first
      comm.namespace = 'admin'
      comm.save!
    end
  end

  def load_order_row(row)
    user = nil
    return unless row[4]
    user = User.find_by(email: row[4].downcase.strip)

    unless user
      user = User.create!(
               email: row[4].downcase.strip,
               first_name: row[1].split(' ')[0],
               last_name: row[1].split(' ')[1..],
               phone: row[3],
               password: '2n9n2dn23d2d',
               password_confirmation: '2n9n2dn23d2d'
             )

    end

    raise unless user
    entity = ExternalEntity.find_by(name: row[5])

    unless entity
      entity = ExternalEntity.create!(
        name: row[5],
        user: user
      )
    end
    raise unless entity
    unless entity.address
      Address.create!(
        line_1: row[6],
        locality: row[8],
        administrative_area: row[7],
        country: "PE",
        addressable: entity
      )
    end

    unless entity.user
      entity.user = user
      entity.save!
    end

    if entity.user.id != user.id
      comm = ActiveAdmin::Comment.new
      comm.resource = entity
      comm.body = "Contacto Adicional: #{row[1]} - #{row[4]} - #{row[3]}"
      comm.author = User.first
      comm.namespace = 'admin'
      comm.save!
    end

    order = Order.new
    order.external_entity = entity
    order.save!

    InventoryLine.create!(
      inventoried: order,
      product_id: 2,
      quantity_present: row[11].to_i,
      quantity_desired: row[10].to_i
    )

    if row[14].present?
      comm = ActiveAdmin::Comment.new
      comm.resource = order
      comm.body = row[14]
      comm.author = User.first
      comm.namespace = 'admin'
      comm.save!
    end
  end
end
# rubocop:enable all
