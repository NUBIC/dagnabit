print "Using native SQLite3\n"

require 'logger'

# The SQLite3 Ruby driver can be present as either a gem or directly present in
# the Ruby library load path.  This load method addresses these two situations.
begin
  require 'sqlite3'
rescue LoadError
  require 'rubygems'
  gem 'sqlite3-ruby'
  require 'sqlite3'
end

ActiveRecord::Base.logger = Logger.new("debug.log")

class SqliteError < StandardError
end

ActiveRecord::Base.configurations = {
  'ActiveRecord::Base' => { :adapter => 'sqlite3', :database => ':memory:' }
};

ActiveRecord::Base.establish_connection('ActiveRecord::Base')
