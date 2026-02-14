class CreateAdmins < ActiveRecord::Migration[7.2]
  def change
    create_table :admins do |t|
      t.string :uid, null: false

      t.timestamps
    end

    add_index :admins, :uid, unique: true
  end
end