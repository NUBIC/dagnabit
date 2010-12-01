require 'active_record'

class OtherVertex < ActiveRecord::Base
  extend Dagnabit::Vertex::Activation

  acts_as_vertex
  set_edge_model OtherEdge
end
