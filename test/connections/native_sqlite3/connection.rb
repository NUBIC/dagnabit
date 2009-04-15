print "Using native SQLite3\n"

require 'logger'

ActiveRecord::Base.logger = Logger.new("debug.log")

class SqliteError < StandardError
end

ActiveRecord::Base.configurations = {
  'ActiveRecord::Base' => { :adapter => 'sqlite3', :database => ':memory:' }
};

ActiveRecord::Base.establish_connection('ActiveRecord::Base')
