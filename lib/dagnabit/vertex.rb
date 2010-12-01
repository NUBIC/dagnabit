require File.join(File.dirname(__FILE__), %w(.. dagnabit))

module Dagnabit::Vertex
  autoload :Activation,   'dagnabit/vertex/activation'
  autoload :Bonding,      'dagnabit/vertex/bonding'
  autoload :Connectivity, 'dagnabit/vertex/connectivity'
  autoload :Neighbors,    'dagnabit/vertex/neighbors'
  autoload :Settings,     'dagnabit/vertex/settings'
end
