require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Carom
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

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
        from: 'Scheduler <proposal@mckinsey.com>',
        no_reply: 'Scheduler <no-reply@mckinsey.com>',
        charset: 'utf-8',
        mime_version: '1.0',
        implicit_parts_order: ['text/html', 'text/plain']
    }

    config.action_mailer.delivery_method = :smtp
    config.smtp_settings = Rails.application.credentials.config.dig(:smtp_settings)
    config.holy_basil_connector = Rails.application.credentials.config.dig(:holy_basil_connector)
    config.fennel_connector = Rails.application.credentials.config.dig(:fennel_connector)

    config.notify_dev_team_at = ENV.fetch("notify_dev_team_at") {"dope_notifications-aaaaeywbsjgnkwuvbslxbaikvu@mckinsey.org.slack.com"}

    # Exception notification configuration
    config.middleware.use ExceptionNotification::Rack,
                          email: {
                              email_prefix: "[#{Rails.env.capitalize}][Carom Exception]",
                              sender_address: config.notify_dev_team_at,
                              exception_recipients: [config.notify_dev_team_at]
                          }

    # The released versions change the default YAML deserializer to use YAML.safe_load, which prevents deserialization of possibly dangerous objects. This may introduce backwards compatibility issues with existing data
    # https://discuss.rubyonrails.org/t/cve-2022-32224-possible-rce-escalation-bug-with-serialized-columns-in-active-record/81017
    # Todo: should be removed once rails by default add the mentioned classes in yaml_safe_load.
    config.active_record.yaml_column_permitted_classes = [Symbol, Time, ActiveSupport::TimeWithZone, ActiveSupport::TimeZone, ActiveSupport::HashWithIndifferentAccess]

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
