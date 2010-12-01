require 'active_record'

class Vertex < ActiveRecord::Base
  extend Dagnabit::Vertex::Activation

  acts_as_vertex
  set_edge_model Edge
end
