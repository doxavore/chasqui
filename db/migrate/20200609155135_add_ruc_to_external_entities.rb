class AddRucToExternalEntities < ActiveRecord::Migration[6.0]
  def change
    add_column :external_entities, :ruc, :string
  end
end
