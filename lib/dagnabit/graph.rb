require File.join(File.dirname(__FILE__), %w(.. dagnabit))

module Dagnabit
  ##
  # A set comprising a collection of vertices and edges.
  #
  # Graphs may be constructed from a set of source nodes with {.from_roots}.
  class Graph
    ##
    # The vertices of this graph.
    #
    # @return [Array<ActiveRecord::Base>]
    attr_accessor :vertices

    ##
    # The edges of this graph.
    #
    # @return [Array<ActiveRecord::Base>]
    attr_accessor :edges

    ##
    # Given a set of `vertices`, builds a subgraph from those vertices and their
    # descendants.
    #
    # This method is intended to be used in the case where `vertices` contains
    # only source vertices (vertices having indegree zero), but can be used with
    # non-source vertices as well.
    #
    # If your vertices may be one of many subclasses (i.e. you're using single
    # table inheritance in your vertices table), then you should use the base
    # class for `vertex_model`.
    #
    # @param [Array<ActiveRecord::Base>] vertices the vertices to start from
    # @param [Class] vertex_model the model class used for representing vertices
    # @param [Class] edge_model the model class used for representing edges
    # @return [Subgraph] a subgraph
    def self.from_vertices(vertices, vertex_model, edge_model)
      new.tap do |g|
        g.vertices = vertices + vertex_model.descendants_of(*vertices)
        g.edges = edge_model.connecting(*g.vertices)
      end
    end

    def initialize
      self.vertices = []
      self.edges = []
    end
  end
end
