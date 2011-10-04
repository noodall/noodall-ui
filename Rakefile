#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'NoodallUi'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'


Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

desc "Compile assets for rails 3.0.x"
task :compile_assets do
  require 'sprockets'

  sprockets = Sprockets::Environment.new

  sprockets.append_path(File.expand_path("../app/assets/javascripts", __FILE__))
  sprockets.append_path(File.expand_path("../app/assets/stylesheets", __FILE__))
  sprockets.append_path(File.expand_path("../vendor/assets/stylesheets", __FILE__))
  sprockets.append_path(File.expand_path("../vendor/assets/javascripts", __FILE__))

  css = sprockets.find_asset("admin.css")
  css.write_to(File.expand_path("../public/stylesheets/admin.css", __FILE__))
  js = sprockets.find_asset("admin.js")
  js.write_to(File.expand_path("../public/javascripts/admin.js", __FILE__))

end


task :default => :test
