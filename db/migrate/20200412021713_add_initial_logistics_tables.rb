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
      t.references :addressable, polymorphic: true, index: true, null: false
      t.timestamps
    end

    create_table :collection_points do |t|
      t.string :name
      t.references :coordinator, foreign_key: { to_table: :users }, index: true, null: false
      t.timestamps
    end

    create_table :printers do |t|
      t.string :name
      t.references :user, index: true, null: false
      t.references :printer_model, index: true
      t.timestamps
    end

    add_reference :users, :coordinator, foreign_key: { to_table: :users }, index: true

    add_column :users, :admin, :boolean
  end
end
