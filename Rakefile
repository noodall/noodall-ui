require 'bundler'
Bundler.setup(:default, :development)
Bundler::GemHelper.install_tasks
require "rspec/core/rake_task"
require "noodall-core"

RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.rcov = true
end

task :default => :spec

#require File.expand_path('../config/application', __FILE__)

#Noodall::Application.load_tasks
