class CreatePokes < ActiveRecord::Migration[6.1]
  def change
    create_table :pokes do |t|
      t.references :team
      t.boolean :live, default: false, index: true
      t.string :frequency, index: true
      t.text :other_attributes, size: :long
      t.timestamps
    end
  end
end
