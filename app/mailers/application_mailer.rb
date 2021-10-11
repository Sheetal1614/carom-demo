class ApplicationMailer < ActionMailer::Base

  # --------- Defaults -----------------------------------------------------
  default from: 'Schedular <opportunity@mckinsey.com>'

  # --------- Constants ----------------------------------------------------
  SMART_LOP = 'smart_lop_dev_team@mckinsey.com'

  # --------- Layout -------------------------------------------------------
  layout 'mailer'

  def self.provision_name_in_default_email(email)
    email.gsub(/(<.*>)/i, "via #{default[:from]}")
  end
end
