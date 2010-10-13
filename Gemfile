source 'http://rubygems.org'
source 'http://gems.github.com'

gemspec

# Required for running as demo rails app
gem 'rails', '3.0.0'
gem 'bson_ext', '~> 1.1.0'
gem 'rmagick', :require => 'RMagick'
gem 'dragonfly', '~> 0.7.6'
gem 'newbamboo-rvideo', '~> 0.9.6'
gem 'open4', '~> 0.9.5'
gem 'dynamic_form'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'rspec-rails', "~> 2.0.0.beta.22"
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
  gem 'jeweler', '~> 1.4.0'
  gem 'factory_girl_rails'
  gem "faker", "~> 0.3.1"
  gem "haml"
end
