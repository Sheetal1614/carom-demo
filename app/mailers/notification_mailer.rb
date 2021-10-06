class NotificationMailer < ApplicationMailer

  def notify_team_members_for_inactive_poke(poke)
    @poke = poke

    mail(to: poke.account.team.team_members.pluck(:email),
         subject: "Poke URL became '#{Poke::INACTIVE}' for account: #{poke.account.name}")
  end

end
