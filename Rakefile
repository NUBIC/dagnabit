require 'rake/gempackagetask'
require 'rspec/core/rake_task'

gemspec = eval(File.read('dagnabit.gemspec'), binding, 'dagnabit.gemspec')
spec_path = File.expand_path('spec', File.dirname(__FILE__))

Rake::GemPackageTask.new(gemspec).define

RSpec::Core::RakeTask.new('spec:postgresql') do |t|
  t.rspec_opts = "-I#{spec_path}/connections/postgresql -I#{spec_path}"
end

task :spec => 'spec:postgresql'
