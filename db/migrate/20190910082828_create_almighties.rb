class CreateAlmighties < ActiveRecord::Migration[6.0]
  def change
    create_table :almighties do |t|
      t.string :name
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest
      t.timestamps
    end
  end
end
