source 'http://rubygems.org'
source 'http://gems.github.com'

gemspec

# Required for running as demo rails app
gem 'rails'
gem 'dragonfly'
gem 'mm-versionable'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'compass'
end

gem 'tinymce-rails'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'rspec-rails', "~> 2.0.0"
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
  gem 'jeweler', '~> 1.4.0'
  gem 'factory_girl', '~> 2.0'
  gem 'factory_girl_rails'
  gem "faker", "~> 0.3.1"
  gem "bson_ext"

  unless ENV["CI"]
    platform :mri_19 do
      gem "ruby-debug19"
    end
  end
  #gem "SystemTimer", ">= 1.2.0" # Ruby-1.8.7 only
end
