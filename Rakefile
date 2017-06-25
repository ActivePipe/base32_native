require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'rake/extensiontask'

spec = Gem::Specification.load('base32_native.gemspec')
Rake::ExtensionTask.new('base32_native', spec)

# RSpec::Core::RakeTask.new(:spec)
# task :default => :spec
