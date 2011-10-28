require 'dynamic_form'
require 'will_paginate'
require 'noodall/site'

module Noodall
  class Engine < Rails::Engine

    if Rails::VERSION::MINOR == 0 # if rails 3.0.x
      initializer "static assets" do |app|
        app.middleware.use ::ActionDispatch::Static, File.join(root, 'app', 'assets')
        app.middleware.use ::ActionDispatch::Static, File.join(root, 'vendor', 'assets')
        app.middleware.use ::ActionDispatch::Static, File.join(root, 'public')
      end
    else
      initializer "Add noodall assets to precomiler" do |app|
        app.config.assets.precompile += %w( admin.css admin.js admin/ie6.css  admin/ie.css  admin/ie8.css admin/tinymce.css  )
      end
    end

    initializer "load site map" do |app|
      begin
        Noodall::Site.map = YAML::load(File.open(File.join(Rails.root, 'config', 'sitemap.yml')))
      rescue Exception => e
        puts "Failed to load noodall site map: #{e}"
      end
    end

  end
end

