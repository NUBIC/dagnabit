require 'active_record'

class OtherVertex < ActiveRecord::Base
  extend Dagnabit::Vertex::Connectivity
  extend Dagnabit::Vertex::Settings

  include Dagnabit::Vertex::Bonding
  include Dagnabit::Vertex::Neighbors

  set_edge_model OtherEdge
end
