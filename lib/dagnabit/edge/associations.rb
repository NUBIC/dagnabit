require File.join(File.dirname(__FILE__), %w(.. edge))

module Dagnabit::Edge
  module Associations
    def connects(vertex_class)
      belongs_to :parent, :class_name => vertex_class, :foreign_key => 'parent_id'
      belongs_to :child,  :class_name => vertex_class, :foreign_key => 'child_id'
    end
  end
end
