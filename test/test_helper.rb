require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'active_record'
require 'active_record/fixtures'
require 'connection'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'dagnabit'

FIXTURES_ROOT = File.join(File.dirname(__FILE__), 'fixtures')
SCHEMA_ROOT = File.join(File.dirname(__FILE__), 'schema')

class ActiveRecord::TestCase
  include ActiveRecord::TestFixtures

  self.fixture_path = FIXTURES_ROOT
  self.use_transactional_fixtures = true

  fixtures :all
end

load (SCHEMA_ROOT + '/schema.rb')
