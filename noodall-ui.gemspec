# -*- encoding: utf-8 -*-
require File.expand_path("../lib/noodall/ui/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "noodall-ui"
  s.version = Noodall::UI::VERSION
  s.platform    = Gem::Platform::RUBY

  s.authors = ["Steve England"]
  s.email = ['steve@wearebeef.co.uk']
  s.homepage = "http://github.com/beef/noodall-ui"
  s.summary = "Noodall Rails User Interface"
  s.description = "Noodall Rails User Interface Engine. Requires Noodall Core"

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency 'noodall-core', ">= 0"
  s.add_dependency 'thoughtbot-sortable_table', "= 0.0.6"
  s.add_dependency 'will_paginate', "~> 3.0.pre2"
  s.add_dependency 'dynamic_form', ">= 0"

  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end

