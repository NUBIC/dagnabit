require File.join(File.dirname(__FILE__), 'bootstrap')

require 'rake'
require 'yaml'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'dagnabit'
    gem.summary = %Q{Directed acyclic graph plugin for ActiveRecord}
    gem.email = 'yipdw@northwestern.edu'
    gem.homepage = 'http://gitorious.org/dagnabit/dagnabit'
    gem.authors = ['David Yip']
    gem.add_dependency 'activerecord', '2.3.5'
    gem.add_development_dependency 'mocha', '= 0.9.8'
    gem.add_development_dependency 'shoulda', '= 2.10.2'
    gem.add_development_dependency 'jeweler'

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts 'Jeweler not available. Install it with: sudo gem install jeweler'
end

task :test => [:test_sqlite3, :test_postgresql]

require 'rake/testtask'
['sqlite3', 'postgresql'].map { |adapter| ["test_#{adapter}", "native_#{adapter}"] }.each do |task_name, adapter_name|
  Rake::TestTask.new(task_name) do |test|
    test.libs << 'lib' << 'test' << "test/connections/#{adapter_name}"
    test.pattern = 'test/dagnabit/**/test_*.rb'
    test.verbose = false
  end
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test' << 'test/connections/native_sqlite3'
    test.pattern = 'test/dagnabit/**/test_*.rb'
    test.verbose = true
    test.rcov_opts << '--exclude gems/*'
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end


task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "dagnabit #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
