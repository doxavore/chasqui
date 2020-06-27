# frozen_string_literal: true

class MigrateEeUsers < ActiveRecord::Migration[6.0]
  def up
    create_table :external_entity_users do |t|
      t.references :user, index: true, null: false
      t.references :external_entity, index: true, null: false
    end

    statement = <<-SQL
      INSERT INTO external_entity_users (user_id, external_entity_id)
      SELECT user_id, id FROM external_entities WHERE user_id IS NOT NULL
    SQL

    ActiveRecord::Base.connection.execute(statement)
  end

  def down
    drop_table :external_entitiy_users
  end
end
