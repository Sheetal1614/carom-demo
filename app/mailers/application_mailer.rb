class ApplicationMailer < ActionMailer::Base

  # --------- Defaults -----------------------------------------------------
  default from: 'Scheduler <opportunity@mckinsey.com>'

  # --------- Layout -------------------------------------------------------
  layout 'mailer'

  def self.provision_name_in_default_email(email)
    email.gsub(/(<.*>)/i, "via #{default[:from]}")
  end
end
