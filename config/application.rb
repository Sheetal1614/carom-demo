# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Carom
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: %i[get post put delete options]
      end
    end

    # Ignore bad email addresses and do not raise email delivery errors.
    # Set this to true and configure the email server for immediate delivery to raise delivery errors.
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default_options = {
        from: 'Scheduler <opportunity@mckinsey.com>',
        no_reply: 'Scheduler <no-reply@mckinsey.com>',
        charset: 'utf-8',
        mime_version: '1.0',
        implicit_parts_order: ['text/html', 'text/plain']
    }

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        address: 'smtp.mckinsey.com',
        domain: 'smtp.mckinsey.com',
        port: 587,
        authentication: :login,
        enable_starttls_auto: true,
        user_name: ENV['OPPORTUNITY_MAILER_USERNAME'],
        password: ENV['OPPORTUNITY_MAILER_PASSWORD']
    }

    config.notify_dev_team_at = ENV.fetch("notify_dev_team_at") {"dope_notifications-aaaaeywbsjgnkwuvbslxbaikvu@mckinsey.org.slack.com"}

    # Exception notification configuration
    config.middleware.use ExceptionNotification::Rack,
                          email: {
                              email_prefix: "[#{Rails.env.capitalize}][Carom Exception]",
                              sender_address: config.notify_dev_team_at,
                              exception_recipients: [config.notify_dev_team_at]
                          },
                          splunk: {},
                          error_grouping: true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
