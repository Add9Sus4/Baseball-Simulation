source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
# will_paginate
gem 'will_paginate', '~> 3.0.5'
# Use bootstrap pagination styles
gem 'bootstrap-will_paginate', '0.0.10'
# Bootstrap
gem 'bootstrap-sass', '3.2.0.0'
# Use bcrypt to hash passwords
gem 'bcrypt', '3.1.10'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.13', '< 0.5'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'faker', '~> 1.6', '>= 1.6.1'
# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'jquery-ui-rails'

gem 'jquery-turbolinks'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'factory_girl_rails', "~> 4.0"
  gem 'rspec-rails'
  gem 'byebug'
end

group :test do
  gem 'capybara'
  gem 'guard-rspec'
  gem 'launchy'
end

group :production do
  gem 'pg', '~> 0.18.4'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
