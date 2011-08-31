require 'active_record'
require 'logger'

puts 'Using PostgreSQL adapter'

ActiveRecord::Base.logger = Logger.new('debug.log')

if ENV['TRAVIS']
  ActiveRecord::Base.configurations = {
    'ActiveRecord::Base' => {
      :adapter => 'postgresql',
      :database => 'dagnabit_test',
      :username => 'postgres'
    }
  }
else
  ActiveRecord::Base.configurations = {
    'ActiveRecord::Base' => {
      :adapter => 'postgresql',
      :database => 'dagnabit_test',
      :username => 'dagnabit_test',
      :password => 'dagnabit_test',
      :host => 'localhost'
    }
  }
end

ActiveRecord::Base.establish_connection('ActiveRecord::Base')
