class AdjustTeamAndTeamLeaders < ActiveRecord::Migration[6.1]
  def up
    # Generate team leaders for team
    Team.find_each.with_index do |team, index|
      user = team.team_leaders.find_or_initialize_by(email: team.email).tap do |_user|
        _user.fmno ||= index #index as dummy fmno
        _user.name ||= team.name
        _user.application_admin ||= team.application_admin
        _user.password_digest ||= team.password_digest
      end
      unless user.save
        puts user.errors.inspect
      end
    end

    # Remove not required columns
    remove_columns(:teams, :email, :password_digest)
  end

  def down
    # Add columns
    add_column(:teams, :email, :string, null: false, after: :name)
    add_column(:teams, :password_digest, :string, after: :email)

    # Reverse populate teams
    Team.find_each do |team|
      if (_user = team.team_leaders.first)
        team.email = _user.email
        team.password_digest = _user.password_digest
        team.save
      end
    end
  end
end
