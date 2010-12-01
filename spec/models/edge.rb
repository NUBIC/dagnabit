require 'active_record'

class Edge < ActiveRecord::Base
  extend Dagnabit::Edge::Associations
  extend Dagnabit::Edge::Connectivity

  edge_for 'Vertex'
end
