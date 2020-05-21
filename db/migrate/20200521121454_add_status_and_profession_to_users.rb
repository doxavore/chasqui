class AddStatusAndProfessionToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :profession, :string
    add_column :users, :status, :string
  end
end
