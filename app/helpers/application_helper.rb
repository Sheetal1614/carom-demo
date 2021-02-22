module ApplicationHelper

  def app_name
    ({
        integration: 'Cron service (Integration)',
        qa: 'Cron service (Qa)',
        production: 'Cron service'
    }[Rails.env.to_sym]) || 'Carom'
  end

end
