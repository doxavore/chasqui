# frozen_string_literal: true

class AddInitialLogisticsTables < ActiveRecord::Migration[6.0]
  def change
    create_table :printer_models do |t|
      t.string :name
      t.integer :x_mm
      t.integer :y_mm
      t.integer :z_mm
      t.boolean :petg
      t.boolean :abs
      t.timestamps
    end

    create_table :addresses do |t|
      t.string :line_1
      t.string :line_2
      t.string :locality
      t.string :administrative_area
      t.string :postal_code
      t.string :country
      t.string :lat
      t.string :lon
      t.timestamps
    end

    create_table :collection_points do |t|
      t.string :name
      t.integer :coordinator_id
      t.integer :address_id
      t.timestamps
    end

    add_foreign_key :collection_points, :users, column: :coordinator_id, index: true
    add_foreign_key :collection_points, :addresses

    create_table :printers do |t|
      t.string :name
      t.integer :user_id, index: true
      t.integer :printer_model_id
      t.timestamps
    end

    add_foreign_key :printers, :users
    add_foreign_key :printers, :printer_models, null: true

    add_column :users, :coordinator_id, :integer, index: true
    add_foreign_key :users, :users, column: :coordinator_id, null: true

    add_column :users, :address_id, :integer
    add_foreign_key :users, :addresses

    add_column :users, :admin, :boolean
  end
end
