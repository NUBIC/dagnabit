class Vertex < ActiveRecord::Base
  extend Dagnabit::Vertex::Activation

  acts_as_vertex
  connected_by  'Edge'
end
