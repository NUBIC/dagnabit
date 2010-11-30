require File.join(File.dirname(__FILE__), %w(.. edge))

module Dagnabit::Edge
  module Associations
    def edge_for(vertex_class)
      belongs_to :parent, :class_name => vertex_class
      belongs_to :child,  :class_name => vertex_class
    end
  end
end
