require 'active_record'

class OtherEdge < ActiveRecord::Base
  extend Dagnabit::Edge::Activation

  acts_as_edge
  connects 'OtherVertex'
end
