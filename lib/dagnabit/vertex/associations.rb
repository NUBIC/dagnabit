require File.join(File.dirname(__FILE__), %w(.. vertex))

module Dagnabit::Vertex
  ##
  # Associates a vertex with its edges.
  module Associations
    include Settings

    ##
    # An override of {Settings#connected_by} that installs `has_many`
    # associations named `parent_edges` and `child_edges` on a vertex model.
    #
    # `parent_edges` is the collection of edges that flow _into_ a vertex;
    # `child_edges` is the collection of edges that flow _out of_ a vertex.
    #
    # `parents` is the collection of vertices with edges that flow _into_ a vertex;
    # `children` is the collection of vertices with edges that flow _out of_ a vertex.
    #
    # @return [void]
    def connected_by(*args)
      super

      has_many :parent_edges,  :class_name => edge_model_name, :foreign_key => 'child_id',  :dependent => :destroy
      has_many :child_edges, :class_name => edge_model_name, :foreign_key => 'parent_id', :dependent => :destroy

      has_many :parents,  :through => :parent_edges
      has_many :children, :through => :child_edges

    end
  end
end
