print "Using native PostgreSQL\n"

require 'logger'

ActiveRecord::Base.logger = Logger.new("debug.log")

ActiveRecord::Base.configurations = {
  'ActiveRecord::Base' => {
    :adapter => 'postgresql',
    :database => 'dagnabit_test',
    :username => 'dagnabit_test',
    :password => 'dagnabit_test',
    :hostname => 'localhost'
  }
};

ActiveRecord::Base.establish_connection('ActiveRecord::Base')
