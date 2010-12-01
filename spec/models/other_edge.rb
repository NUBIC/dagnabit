require 'active_record'

class OtherEdge < ActiveRecord::Base
  extend Dagnabit::Edge::Associations
  extend Dagnabit::Edge::Connectivity

  edge_for 'OtherVertex'
end
