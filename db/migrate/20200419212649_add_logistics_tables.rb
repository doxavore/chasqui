class AddLogisticsTables < ActiveRecord::Migration[6.0]
  def change
    create_table :inventory_lines do |t|
      t.references :inventoried, polymorphic: true, index: true, null: false
      t.integer :quantity_present
      t.integer :quantity_desired
      t.references :product, index: true, null: false
      t.timestamps
    end

    create_table :receipts do |t|
      t.references :origin, polymorphic: true, index: true, null: false
      t.references :destination, polymorphic: true, index: true, null: false
      t.string :state
      t.timestamps
    end

    create_table :external_entities do |t|
      t.string :name
      t.references :user, index: true
      t.timestamps
    end

    create_table :orders do |t|
      t.references :external_entity, index: true, null: false
      t.string :state
      t.timestamps
    end

    create_table :product_assignments do |t|
      t.references :product, index: true, null: false
      t.references :assigned, polymorphic: true, index: true, null: false
    end
  end
end
