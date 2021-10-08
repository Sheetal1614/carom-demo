class NotificationMailer < ApplicationMailer

  def notify_team_members_for_inactive_poke(poke)
    @poke = poke

    mail(to: poke.team.team_members.pluck(:email),
         subject: "Poke URL became '#{Poke::INACTIVE}' for team: #{poke.team.name}")
  end

end
