require File.join(File.dirname(__FILE__), %w(.. dagnabit))

module Dagnabit::Edge
  autoload :Connectivity, 'dagnabit/edge/connectivity'
  autoload :Settings,     'dagnabit/edge/settings'
end
