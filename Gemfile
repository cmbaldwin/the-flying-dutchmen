source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

# Set up local .env file, require immediately
gem 'dotenv-rails', groups: [:development, :test], :require => 'dotenv/rails-now'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4', '>= 6.1.4.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
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
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Devise for the forum user model and more
gem 'devise'

# Simple Forum, require our fork of the gem instead of the main gem so we can make modifications
gem 'fora', :git => 'https://github.com/cmbaldwin/fora.git', branch: "master"
gem 'bootstrap-icons-helper'
#Uncomment for Fora dev enviornment, path should be ~/fora (eg. `git clone github.com/cmbaldwin/fora.git ~/`)
#gem 'fora', :path => '~/fora'

# Support for Rich Text image processing
# # Auto-upload setup for Google
# # Setup credentials is here: https://devdojo.com/bryanborge/adding-google-cloud-credentials-to-heroku
# # Cors settings example methods are in lib/google_cloud_bucket_library.rb
gem "google-cloud-storage", "~> 1.11"
gem 'active-storage-ftp'
gem 'image_processing', '~> 1.2'

# Carrierwave if wanting to add custom attachments to models later
# gem 'carrierwave'
# gem 'carrierwave-google-storage'
# gem 'google-api-client'