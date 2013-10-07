 source 'https://rubygems.org'

gem 'rails', '3.2.9'
gem 'pg'                                         # Database
gem 'jquery-rails'                               # jQuery
gem 'jquery-ui-rails'                            # jQuery UI

gem 'haml'                                       # HAML Views
gem 'devise'                                     # User Auth / Registration
gem 'will_paginate'                              # Pagination
gem 'simple_form'                                # Rails form builder
gem 'scoped_search'                              # Active Record Easy Search
gem 'geocoder'                                   # Geocoding solution for rails
gem 'bootstrap-wysihtml5-rails'                  # Bootstrap template
gem 'ffaker'                                     # Generate random data
# gem 'exception_notification', git: 'git://github.com/smartinez87/exception_notification.git' # Exception notification
gem 'country-select'                             # Country select for admin
gem 'icalendar'                                  # ICS output for calendar
gem 'pusher'                                     # Push notifications and messaging
gem 'rails_admin'                                # Admin
gem 'thumbs_up'                                  # Stack Overflow like voting on things
gem 'delayed_job_active_record'                  # For threaded email sending
gem 'workless', "~> 1.1.3"                       # Start worker ad hoc

group :production do
  gem 'heroku_rails_deflate'
end

group :development, :test do
  gem 'rspec-rails'                              # RSpec support for rails
  gem 'guard-rspec'                              # Automatically run RSpec tests
  gem 'capybara'                                 # Browser Engine
  gem 'haml-rails'                               # Haml generator
  gem 'wirble'
  gem 'awesome_print'                                   # Colors on console
  gem 'pry'
end

group :development do
  gem "daemons"
end


group :assets do
  gem 'sass-rails', '>= 3.2.5'                   # SASS Support
  gem "sass_rails_patch", "~> 0.0.1"             # Needed to make rails_admin work
  gem 'coffee-rails', '>= 3.2.1'                 # Cofeescript compilation
  gem 'uglifier', '>= 1.2.3'                     # JS Minimizer
end

group :test do
  gem 'simplecov'                                # Code coverage
  gem 'database_cleaner'                         # Clean database strategy
  gem 'factory_girl_rails'                       # Fixtures

  gem 'launchy'                                  # To open pages when developing capybara tests
  #gem 'ruby-debug19', require: 'ruby-debug'      # Debug on testing
  gem 'debugger'

  gem 'email_spec'                               # Email for rspec
  gem 'rb-fsevent', require: false               # Mac OSX FSEvents API
  gem 'growl'                                    # Ruby growlnotify bindings
  gem 'guard-spork'                              # Automatic DRB Server
  gem 'spork'                                    # DRB Server that forks before each run
end