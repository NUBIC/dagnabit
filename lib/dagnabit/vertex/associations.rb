require File.join(File.dirname(__FILE__), %w(.. vertex))

module Dagnabit::Vertex
  ##
  # Associates a vertex with its edges.
  module Associations
    include Settings

    ##
    # An override of {Settings#connected_by} that installs `has_many`
    # associations named `in_edges` and `out_edges` on a vertex model.
    #
    # `in_edges` is the collection of edges that flow _into_ a vertex;
    # `out_edges` is the collection of edges that flow _out of_ a vertex.
    #
    # @return [void]
    def connected_by(*args)
      super

      has_many :in_edges,  :class_name => edge_model_name, :foreign_key => 'child_id',  :dependent => :destroy
      has_many :out_edges, :class_name => edge_model_name, :foreign_key => 'parent_id', :dependent => :destroy
    end
  end
end
