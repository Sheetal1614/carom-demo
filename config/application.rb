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

    # Exception notification configuration
    config.middleware.use ExceptionNotification::Rack, email: {
        email_prefix: "[#{Rails.env.capitalize}][Carom Exception]",
        sender_address: %(smart_lop_dev_team@mckinsey.com),
        exception_recipients: %w[smart_lop_dev_team@mckinsey.com]
    },
    splunk: {},
    error_grouping: true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
