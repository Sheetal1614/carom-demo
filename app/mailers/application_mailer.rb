class ApplicationMailer < ActionMailer::Base

  # --------- Defaults -----------------------------------------------------
  default from: 'Scheduler <proposal@mckinsey.com>'

  # --------- Layout -------------------------------------------------------
  layout 'mailer'

  def self.provision_name_in_default_email(email)
    email.gsub(/(<.*>)/i, "via #{default[:from]}")
  end
end
