require 'active_record'

class Edge < ActiveRecord::Base
  extend Dagnabit::Edge::Activation

  acts_as_edge
  connects 'Vertex'
end
