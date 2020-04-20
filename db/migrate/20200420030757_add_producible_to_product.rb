class AddProducibleToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :producible, :boolean
    add_index :product_assignments, [:assigned_type, :assigned_id, :product_id], name: 'idx_pa_at_ai_pi', unique: true
  end
end
