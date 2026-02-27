class AddUserIdToAdmins < ActiveRecord::Migration[7.2]
  def change
    # 1) user_id カラムを追加（参照・外部キー）
    add_reference :admins, :user, null: true, foreign_key: true, index: false

    # 2) インデックスは “別名” で unique を付ける（衝突回避）
    add_index :admins, :user_id, unique: true, name: "index_admins_on_user_id_unique"
  end
end