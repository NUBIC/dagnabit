require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'active_record'
require 'active_record/fixtures'
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
