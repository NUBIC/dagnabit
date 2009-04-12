print "Using native SQLite3\n"

require 'logger'

ActiveRecord::Base.logger = Logger.new("debug.log")

class SqliteError < StandardError
end

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
