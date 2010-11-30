require 'rake/gempackagetask'
require 'rspec/core/rake_task'
require 'yard'

gemspec = eval(File.read('dagnabit.gemspec'), binding, 'dagnabit.gemspec')
spec_path = File.expand_path('spec', File.dirname(__FILE__))

Rake::GemPackageTask.new(gemspec).define

desc 'Run specs (set database adapter with DATABASE, defaults to postgresql)'
RSpec::Core::RakeTask.new

YARD::Rake::YardocTask.new
