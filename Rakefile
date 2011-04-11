require 'cucumber/rake/task'
require 'rake/gempackagetask'
require 'rspec/core/rake_task'
require 'yard'

gemspec = eval(File.read('dagnabit.gemspec'), binding, 'dagnabit.gemspec')
spec_path = File.expand_path('spec', File.dirname(__FILE__))

Cucumber::Rake::Task.new('cucumber:ok')
Cucumber::Rake::Task.new('cucumber:wip') do |t|
  t.profile = 'wip'
end

desc 'Run all features'
task 'cucumber:all' => ['cucumber:ok', 'cucumber:wip']

Rake::GemPackageTask.new(gemspec).define

desc 'Run specs (set database adapter with DATABASE, defaults to postgresql)'
RSpec::Core::RakeTask.new

namespace :yard do
  desc 'Generate YARD documentation'
  YARD::Rake::YardocTask.new('once')

  desc 'Run the YARD server'
  task :auto do
    sh 'bundle exec yard server --reload'
  end
end
