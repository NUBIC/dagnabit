class OtherVertex < ActiveRecord::Base
  extend Dagnabit::Vertex::Activation

  acts_as_vertex
  connected_by  'OtherEdge'
end
