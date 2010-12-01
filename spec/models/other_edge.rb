require 'active_record'

class OtherEdge < ActiveRecord::Base
  extend Dagnabit::Edge::Activation

  acts_as_edge
  edge_for 'OtherVertex'
end
