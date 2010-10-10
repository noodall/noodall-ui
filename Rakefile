require 'bundler'
Bundler.setup(:default, :development)
require "rspec/core/rake_task"
require "noodall-core"

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "noodall-ui"
    gem.summary = %Q{Noodall Rails User Interface}
    gem.description = %Q{Noodall Rails User Interface Engine. Requires Noodall Core}
    gem.email = "steve@wearebeef.co.uk"
    gem.homepage = "http://github.com/beef/noodall-ui"
    gem.authors = ["Steve England"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    gem.add_dependency('noodall-core')
    gem.add_dependency("thoughtbot-sortable_table", "0.0.6")
    gem.add_dependency('bson_ext', '~> 1.0.9')
    gem.add_dependency('rmagick')
    gem.add_dependency('dragonfly', '~> 0.7.6')
    gem.add_dependency('will_paginate')
    gem.add_dependency('newbamboo-rvideo', '~> 0.9.6')
    gem.add_dependency('open4', '~> 0.9.5')
    gem.add_dependency('ruby-stemmer')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "noodall-ui #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require File.expand_path('../config/application', __FILE__)

Noodall::Application.load_tasks
