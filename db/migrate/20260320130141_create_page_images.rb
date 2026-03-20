class CreatePageImages < ActiveRecord::Migration[7.2]
  def change
    create_table :page_images do |t|
      t.integer :page_type, null: false
      t.integer :slot, null: false
      t.string :image, null: false
      t.integer :position, null: false, default: 1
      t.boolean :published, null: false, default: true

      t.timestamps
    end

    add_index :page_images, :page_type
    add_index :page_images, :slot
    add_index :page_images, [ :page_type, :slot, :published, :position ], name: "index_page_images_on_display_fields"
  end
end
