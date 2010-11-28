require File.join(File.dirname(__FILE__), %w(.. dagnabit))

module Dagnabit::Vertex
  autoload :Connectivity, 'dagnabit/vertex/connectivity'
  autoload :Settings,     'dagnabit/vertex/settings'
end
