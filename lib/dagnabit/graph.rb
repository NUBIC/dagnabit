require File.join(File.dirname(__FILE__), %w(.. dagnabit))

module Dagnabit
  ##
  # A graph is a pair (V, E) where V is a set of vertices and E is a set of
  # nodes.  This class (loosely) implements that definition and adds some
  # useful utility methods.
  #
  # This class is a loose implementation of that definition for a number of
  # reasons.  Here are a couple:
  #
  # * It represents the vertex and edge sets using data structures more akin to
  #   bags than sets.
  # * It imposes an additional restriction on the form of vertices and edges;
  #   namely, that they must be ActiveRecord::Base subclasses that extend
  #   {Vertex::Connectivity}.
  #
  # Despite these flaws, it is hoped that {Graph} is still useful for
  # performing queries on graphs built with dagnabit.
  #
  # {Graph} is not compatible with RGL's Graph concept.  This is because
  # {Graph} defines {#vertices} and {#edges} as accessors, whereas RGL provides
  # implementations of {#vertices} and {#edges} in terms of methods called
  # `each_vertex` and `each_edge`, respectively.  Nevertheless, RGL compatibility would be
  # nice to have, so it is a (currently low priority) to-do item.
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
