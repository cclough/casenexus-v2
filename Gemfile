source 'https://rubygems.org'

gem 'rails', '3.2.8'
gem 'pg'                                         # Database
gem 'jquery-rails'                               # jQuery
gem 'jquery-ui-rails'                            # jQuery UI

gem 'haml'                                       # HAML Views
gem 'devise'                                     # User Auth / Registration
#gem 'kaminari'                                   # Pagination
gem 'will_paginate'                              # Pagination
gem 'simple_form'                                # Rails form builder

gem 'scoped_search'                              # Active Record Easy Search
gem 'geokit-rails3'                              # Location Based for Rails
gem 'geocoder'                                   # Geocoding solution for rails
gem 'amistad'                                    # TODO: Drop this gem
gem 'omniauth'                                   # Authentication with Rack
gem 'omniauth-linkedin'                          # Linkedin plugin for omniauth
gem 'linkedin'                                   # Linkedin client
gem 'bootstrap-wysihtml5-rails'                  # Bootstrap template
gem 'ffaker'                                     # Generate test data, we put it here because of heroku, remove later
gem 'rack-mini-profiler'                         # Profile on the UI


group :development, :test do
  gem 'rspec-rails'                              # RSpec support for rails
  gem 'guard-rspec'                              # Automatically run RSpec tests
  gem 'capybara'                                 # Browser Engine
  gem 'haml-rails'                               # Haml generator
end

group :assets do
  gem 'sass-rails', '>= 3.2.5'                   # SASS Support
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