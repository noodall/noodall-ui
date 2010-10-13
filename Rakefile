require 'bundler'
Bundler.setup(:default, :development)
Bundler::GemHelper.install_tasks
require "rspec/core/rake_task"
require "noodall-core"

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
