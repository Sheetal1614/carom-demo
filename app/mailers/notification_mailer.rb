class NotificationMailer < ApplicationMailer

  def notify_team_members_for_inactive_poke(poke)
    @poke = poke
    @team = poke.team

    mail(to: @team.team_members.pluck(:email),
         subject: "Poke URL became '#{Poke::INACTIVE}' for team: #{@team.name}")
  end

end
