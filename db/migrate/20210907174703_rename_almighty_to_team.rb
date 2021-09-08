class RenameAlmightyToTeam < ActiveRecord::Migration[6.1]
  def change
    rename_table :almighties, :teams
    rename_column :accounts, :almighty_id, :team_id
  end
end
