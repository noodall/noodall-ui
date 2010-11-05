require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

require 'noodall-core'
require 'lib/noodall/permalinks'
require 'lib/noodall/ui'

module Noodall
  class Application < Rails::Application
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    paths.app << 'demo'
    paths.app.views << 'demo/views'
    paths.app.controllers << 'demo/controllers'
    paths.config.routes 'demo/routes.rb'
    paths.config.initializers << "demo/initializers"

    config.middleware.insert_after 'Rack::Lock', 'Dragonfly::Middleware', :noodall_assets, '/media'
  end
end
