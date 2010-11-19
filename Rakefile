require 'rake/gempackagetask'
require 'rspec/core/rake_task'

gemspec = eval(File.read('dagnabit.gemspec'), binding, 'dagnabit.gemspec')

Rake::GemPackageTask.new(gemspec).define
RSpec::Core::RakeTask.new
