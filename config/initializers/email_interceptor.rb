class EmailInterceptor

  # If it is in non-production environment
  def self.delivering_email(message)
    if (not Rails.env.production?)
      message.to = [message.header["To"].value].flatten.collect {|recipient| recipient.gsub(/(<.*>)/i, "<#{Rails.application.config.notify_dev_team_at}>")}
      message.cc = [message.header["Cc"].value].flatten.collect {|recipient| recipient.gsub(/(<.*>)/i, "<#{Rails.application.config.notify_dev_team_at}>")} if message.header["Cc"].present?
      message.bcc = [message.header["Bcc"].value].flatten.collect {|recipient| recipient.gsub(/(<.*>)/i, "<#{Rails.application.config.notify_dev_team_at}>")} if message.header["Bcc"].present?
      message.subject = "[#{Rails.env.capitalize}] #{message.subject}"
    end
  end

end

ActionMailer::Base.register_interceptor(EmailInterceptor)