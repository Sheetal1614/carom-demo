class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string "fmno", null: false, index: { unique: true }
      t.string "name"
      t.string "email", null: false, index: { unique: true }
      t.boolean "application_admin", default: false
      t.string "password_digest"
      t.timestamps
    end
  end
end