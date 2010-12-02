require 'active_record'
require 'logger'

puts 'Using PostgreSQL adapter'

ActiveRecord::Base.logger = Logger.new('debug.log')

ActiveRecord::Base.configurations = {
  'ActiveRecord::Base' => {
    :adapter => 'postgresql',
    :database => 'dagnabit_test',
    :username => 'dagnabit_test',
    :password => 'dagnabit_test',
    :host => 'localhost'
  }
}

ActiveRecord::Base.establish_connection('ActiveRecord::Base')
