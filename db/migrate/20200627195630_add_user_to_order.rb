class AddUserToOrder < ActiveRecord::Migration[6.0]
  def up
    add_reference :orders, :user, foreign_key: { to_table: :users }, index: true
    Order.find_each do |order|
      order.user = order.external_entity.users.first
      order.save
    end
  end

  def down
    remove_reference :orders, :user, foreign_key: { to_table: :users }
  end
end
