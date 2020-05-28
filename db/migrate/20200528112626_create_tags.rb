class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :color
      t.timestamps
    end

    create_table :taggings do |t|
      t.string :name
      t.string :color
      t.references :taggable, polymorphic: true, index: true, null: false
      t.references :tag, index: true, null: false
      t.timestamps
    end
  end
end
