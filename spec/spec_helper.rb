$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), %w(.. .. lib)))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), %w(.. db)))

require 'rspec'

require 'matchers/be_set_equivalent'
require 'matchers/contain_edges'

require 'dagnabit'

require 'connection'
require 'schema'

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
