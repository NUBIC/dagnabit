unless defined?(ActiveRecord)
  begin
    require 'active_record'
  rescue LoadError
    require 'rubygems'
    require_gem 'activerecord'
  end
end

require 'dagnabit/configuration/edge'
require 'dagnabit/activation'

ActiveRecord::Base.extend(Dagnabit::Activation)
