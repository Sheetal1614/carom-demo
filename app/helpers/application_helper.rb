module ApplicationHelper

  def app_name
    ({
        integration: 'Scheduler (Integration)',
        qa: 'Scheduler (Qa)',
        production: 'Scheduler'
    }[Rails.env.to_sym]) || 'Carom'
  end

end
