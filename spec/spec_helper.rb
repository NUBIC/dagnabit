require 'rspec'

require File.expand_path('../lib/dagnabit', File.dirname(__FILE__))

database = ENV['DATABASE'] || 'postgresql'
$LOAD_PATH.unshift(File.expand_path("connections/#{database}", File.dirname(__FILE__)))

require 'connection'
require 'schema'
require 'matchers/be_set_equivalent'
require 'matchers/contain_edges'

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
