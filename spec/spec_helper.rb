require 'active_support'
require 'active_record/fixtures'
require 'rspec'

require File.expand_path('../lib/dagnabit', File.dirname(__FILE__))

class ActiveSupport::TestCase
  include ActiveRecord::TestFixtures

  self.use_transactional_fixtures = true
end

require 'connection'
require 'schema'

RSpec.configure do |config|
end
