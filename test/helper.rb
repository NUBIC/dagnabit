require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'active_record'
require 'active_record/fixtures'
require 'active_support'
require 'active_support/whiny_nil'
require 'connection'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'dagnabit'

SCHEMA_ROOT = File.join(File.dirname(__FILE__), 'schema')

class ActiveSupport::TestCase
  include ActiveRecord::TestFixtures

  self.use_transactional_fixtures = true
end

load(SCHEMA_ROOT + '/schema.rb')

# load link models before other models
models = Dir[File.dirname(__FILE__) + '/models/**/*.rb']
models.sort { |x, y| x =~ /link\.rb$/ ? -1 : 0 }.each { |m| require m }
