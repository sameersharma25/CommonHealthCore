source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.5'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'bootstrap-sass'

gem 'mongoid', '~> 6.1.0'

#CanCan is an authorization library for Ruby on Rails which restricts what resources a given user is allowed to access
gem "cancancan"

#Devise is a flexible authentication solution for Rails based on Warden
gem 'devise'
gem 'devise_invitable'
# Gem to handle nested forms
gem "cocoon"
#Use wicked to make your Rails controllers into step-by-step wizards
gem 'wicked'

gem 'rack-cors', :require => 'rack/cors'

gem 'simple_token_authentication'
# gem 'aws-sdk'
gem 'aws-sdk', '~> 3.0', '>= 3.0.1'
gem 'whenever', require: false
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'jquery-datatables-rails', '~> 3.4.0'
gem 'jquery-turbolinks'

gem 'geocoder'

#for drag and drop
gem 'jquery-ui-rails'
gem 'mongoid_orderable'
#gem 'acts_as_list'

gem 'zip-codes'
gem 'carrierwave'#, :git => "git://github.com/jnicklas/carrierwave.git"
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'mongoid-paperclip', require: 'mongoid_paperclip'
gem 'mini_magick' #, :git => 'git://github.com/probablycorey/mini_magick.git'
gem "fog-aws"
gem "recaptcha", '3.4.0', require: "recaptcha/rails"
gem 'ckeditor', github: 'galetahub/ckeditor'
gem 'devise-two-factor'
gem 'rqrcode', '~> 0.10.1'
gem 'omniauth-google-oauth2'
# gem 'fog'
gem 'apipie-rails'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem 'rb-readline' 
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
