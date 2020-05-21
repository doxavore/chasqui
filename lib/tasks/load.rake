# frozen_string_literal: true
# rubocop:disable all
namespace :load do

  task :orders do
    Rake::Task['environment'].invoke
    arr = CSV.read("#{Rails.root}/lib/tasks/solicitudes.csv")
    arr.each do |row|
      ActiveRecord::Base.transaction(requires_new: true) do
        load_row(row)
      end
    end

  end


  def load_row(row)
    pp row
    user = nil
    return unless row[4]
    user = User.find_by(email: row[4].downcase.strip)

    unless user
      pp 'creating user'
      user = User.new(
               email: row[4].downcase.strip,
               first_name: row[1].split(' ')[0],
               last_name: row[1].split(' ')[1..],
               phone: row[3],
               password: '2n9n2dn23d2d',
               password_confirmation: '2n9n2dn23d2d'
             )
      pp 'done'
      pp user.valid?
    end
    raise 'noo' unless user.save!
    pp 'finding'
    entity = ExternalEntity.find_by(name: row[5])
    pp '1'
    unless entity
      pp 'creating entity'
      entity = ExternalEntity.create!(
        name: row[5],
        user: user
      )
    end
    pp '2'
    entity.save!
    unless entity.address
      pp 'creating address'
      Address.create!(
        line_1: row[6],
        locality: row[8],
        administrative_area: row[7],
        country: "PE",
        addressable: entity
      )
    end

    if entity.user.id != user.id
      pp 'creating entity comment'
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
    pp 'creating inv line'
    InventoryLine.create!(
      inventoried: order,
      product_id: 2,
      quantity_present: row[11].to_i,
      quantity_desired: row[10].to_i
    )

    if row[14].present?
      pp 'creating inv line comment'
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
