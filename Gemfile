source 'https://rubygems.org'
git_source(:github) {|repo| "https://github.com/#{repo}.git"}

ruby '>= 3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 5'
gem 'sprockets'
gem 'sprockets-rails', :require => 'sprockets/railtie'
gem 'bootstrap', '~> 4.4.1'
gem 'jquery-rails'
#For font awesome icons
gem 'font-awesome-sass', '~> 5.15.1'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'
# For CORS request
gem 'rack-cors'
gem 'minitest'
gem 'tzinfo'
# For dumping exceptions logs in splunk via STDOUT
gem 'splunk_notifier', '~> 0.0.3', source: "http://gems.intranet.mckinsey.com"
# For exception notification
gem 'exception_notification'
# For process monitoring # http://godrb.com/
gem 'god'
#For active job #https://github.com/nesquena/backburner
gem 'backburner'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
#For date validations
gem 'date_validator'

gem 'ThymeFieldAccommodator', '~> 0.7.3', source: "http://gems.intranet.mckinsey.com"
# gem 'ThymeFieldAccommodator', path: "./LocalThymeFieldAccommodator"
# gem 'faraday'

# Use select2(jquery based select overload). Ref https://github.com/argerim/select2-rails
gem "select2-rails"

# For process monitoring # http://godrb.com/
gem 'god'

# Use Dalli for memcache connect
gem 'dalli'

# Use for multi-threading in Dalli connection
gem 'connection_pool'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Box API for files and folder sharing
gem 'boxr'

# For A Sinatra app to view/manage beanstalkd queues
gem 'beanstalkd_view'

# Library for generating excel files
gem 'caxlsx'

# JsonPath is a way of addressing elements within a JSON object. Read more: https://github.com/joshbuddy/jsonpath
gem 'jsonpath'

# A framework for creating flexible, powerful admin dashboards in Rails.
gem "administrate"

#State machine
gem 'state_machines-activerecord'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # For memory profiling, For usage visit: https://github.com/SamSaffron/memory_profiler
  gem 'memory_profiler'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
