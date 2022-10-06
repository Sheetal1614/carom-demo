# source "https://rubygems.org"
source "https://mckinsey.jfrog.io/artifactory/api/gems/rubygems"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.4"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.0"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

gem 'bootstrap', '~> 4.4.1'

gem 'jquery-rails'

#For font awesome icons
gem 'font-awesome-sass', '~> 6.1.1'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.8"
gem 'hiredis'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# For CORS request
gem 'rack-cors'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# # For dumping exceptions logs in splunk via STDOUT
# gem 'splunk_notifier', '~> 0.0.3', source: "http://gems.intranet.mckinsey.com"

# For exception notification
gem 'exception_notification'

# For process monitoring # http://godrb.com/
# gem 'god'
gem 'god', '~> 0.13.8.1'

# For active job #https://github.com/nesquena/backburner
gem 'backburner'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
gem "sassc-rails"

#For date validations
gem 'date_validator'

gem 'ThymeFieldAccommodator', '~> 0.8.4'
# gem 'ThymeFieldAccommodator', path: "./LocalThymeFieldAccommodator"
# gem 'faraday'

# Use select2(jquery based select overload). Ref https://github.com/argerim/select2-rails
gem "select2-rails"

# For converting cron expressions into human readable strings
gem 'cronex'

# Use for multi-threading in Dalli connection
gem 'connection_pool'

# For A Sinatra app to view/manage beanstalkd queues
gem 'beanstalkd_view'

# JsonPath is a way of addressing elements within a JSON object. Read more: https://github.com/joshbuddy/jsonpath
gem 'jsonpath'

# A framework for creating flexible, powerful admin dashboards in Rails.
gem "administrate"

#State machine
gem 'state_machines-activerecord'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
