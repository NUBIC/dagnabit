unless defined?(ActiveRecord)
  begin
    require 'active_record'
  rescue LoadError
    require 'rubygems'
    require_gem 'activerecord'
  end
end

require 'dagnabit/configuration'
require 'dagnabit/activators'

ActiveRecord::Base.extend(Dagnabit::Configuration)
ActiveRecord::Base.extend(Dagnabit::Activators)
