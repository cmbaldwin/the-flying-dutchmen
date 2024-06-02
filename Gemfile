source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.1'

# Set up local .env file, require immediately
gem 'dotenv-rails', groups: %i[development test], require: 'dotenv/load'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7'
# Use postgresql as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'cssbundling-rails'
gem 'rack-cache'
gem 'sassc-rails'
gem 'sprockets-rails'
# Importmaps
gem 'importmap-rails'
# Stimulus
gem 'stimulus-rails'
# Turbo
gem 'turbo-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'listen', '~> 3.3'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  # Rubocop
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'ruby-lsp'
  gem 'ruby-lsp-rails'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Devise for the forum user model and more
gem 'devise'

# Fora@5d00032 installed in app, for more on Fora: https://github.com/cmbaldwin/fora
gem 'bootstrap-icons-helper'
gem 'fora', path: 'fora'
gem 'friendly_id'
gem 'will_paginate'

# Support for Rich Text image processing
# # Auto-upload setup for Google
# # See here for how to setup credentials: https://devdojo.com/bryanborge/adding-google-cloud-credentials-to-heroku
# # Cors settings example methods are in lib/google_cloud_bucket_library.rb
gem 'google-cloud-storage', '~> 1.11'
# gem 'active-storage-ftp'
gem 'file_validators'
gem 'image_processing', '~> 1.2'
gem 'imgproxy'
