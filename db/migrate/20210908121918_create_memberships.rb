class CreateMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :memberships do |t|
      t.references :team
      t.references :user
      t.string :kind
      t.timestamps
    end
  end
end
