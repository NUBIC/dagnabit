require File.join(File.dirname(__FILE__), %w(.. vertex))

module Dagnabit::Vertex
  ##
  # Associates a vertex with its edges.
  module Associations
    include Settings

    ##
    # An override of {Settings#connected_by} that installs `has_many`
    # associations named `edges_to_parents` and `edges_to_children` on a vertex model.
    #
    # `edges_to_parents` is the collection of edges that flow _into_ a vertex;
    # `edges_to_children` is the collection of edges that flow _out of_ a vertex.
    #
    # `parents` is the collection of vertices with edges that flow _into_ a vertex;
    # `children` is the collection of vertices with edges that flow _out of_ a vertex.
    #
    # @return [void]
    def connected_by(*args)
      super

      has_many :edges_to_parents,  :class_name => edge_model_name, :foreign_key => 'child_id',  :dependent => :destroy
      has_many :edges_to_children, :class_name => edge_model_name, :foreign_key => 'parent_id', :dependent => :destroy

      has_many :parents,  :through => :edges_to_parents
      has_many :children, :through => :edges_to_children

    end
  end
end
