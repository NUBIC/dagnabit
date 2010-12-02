require File.join(File.dirname(__FILE__), %w(.. dagnabit))

module Dagnabit
  ##
  # This class is a representation of a directed graph.  It deviates from the
  # definition of a directed graph in a few ways; here's a couple:
  #
  # * It represents the vertex and edge sets using data structures more akin to
  #   bags than sets.
  # * It imposes restrictions on the form of vertices and edges; namely, they
  #   must be ActiveRecord::Base subclasses that extend {Vertex::Connectivity}.
  #
  # Despite these flaws, it is hoped that {Graph} is still useful for
  # performing queries on graphs built with dagnabit.
  #
  # {Graph} is not compatible with RGL's Graph concept.  This is because
  # {Graph} defines {#vertices} and {#edges} as accessors, whereas RGL provides
  # implementations of {#vertices} and {#edges} in terms of methods called
  # `each_vertex` and `each_edge`, respectively.  Nevertheless, RGL
  # compatibility would be nice to have, so it is a to-do item.
  #
  # Graphs may be constructed from a set of source nodes with {.from_vertices}.
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
    # The vertex model used by this graph.
    #
    # This must be defined before calling {#load_descendants!}.
    #
    # @return [Class]
    attr_accessor :vertex_model

    ##
    # The vertex model used by this graph.
    #
    # This must be defined before calling {#load_descendants!}.
    #
    # @return [Class]
    attr_accessor :edge_model

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
    # class for {#vertex_model}.
    #
    # @param [Array<ActiveRecord::Base>] vertices the vertices to start from
    # @param [Class] vertex_model the model class used for representing vertices
    # @param [Class] edge_model the model class used for representing edges
    # @return [Graph] a subgraph
    def self.from_vertices(vertices, vertex_model, edge_model)
      new.tap do |g|
        g.vertex_model = vertex_model
        g.edge_model = edge_model
        g.vertices = vertices
        g.load_descendants!
      end
    end

    def initialize
      self.vertices = []
      self.edges = []
    end

    ##
    # Loads all descendants of the vertices in {#vertices}.
    #
    # {#vertex_model} and {#edge_model} must be set before calling this method.
    # If either are not set, this method raises `RuntimeError`.
    #
    # Once vertices are loaded, load_descendants! loads all edges that connect
    # vertices in the working vertex set.
    #
    # Vertices and edges that were present before a load_descendants! call will
    # remain in {#vertices} and {#edges}, respectively.
    #
    # @raise [RuntimeError] if {#vertex_model} or {#edge_model} are unset
    def load_descendants!
      raise 'vertex_model and edge_model must be set' unless vertex_model && edge_model

      self.vertices += vertex_model.descendants_of(*vertices)
      self.edges += edge_model.connecting(*vertices)
    end

    ##
    # Returns the source vertices in the graph.  Sources are not returned in any
    # particular order.
    #
    # This method is implemented using a hash anti-join on vertex ID and edge
    # child ID.  If a vertex is a child of some edge, then it is rejected, and
    # thus only vertices that are not children of any edge (viz. have indegree
    # zero and are therefore sources) remain.
    #
    # If this method is run on a subgraph of a larger graph, then the source
    # determination is done relative to the subgraph.  Consider the following
    # graph:
    #
    #     a   b
    #      \ /
    #       c
    #       |
    #       d
    #
    # When considering the vertex set `{ a, b, c, d }` and corresponding edge
    # set, `c` is clearly not a source.  However, in the subgraph `S`
    #
    #     S = ({c, d}, {(c, d)})
    #
    # `c` _is_ a source, and if S were reified as a {Graph} instance (using, for
    # example, {.from_vertices}), `[c]` would be the output of calling `sources`
    # on that instance.
    #
    # This method expects all vertices and edges to have been persisted, and
    # will return incorrect results if there exist unpersisted vertices or edges
    # in the graph.  For this reason, it is advised that you ensure that all
    # vertices and edges in a graph are saved before calling {#sources}.
    #
    # @return [Array<vertex_model>] an array of source vertices
    def sources
      ids = vertices.inject({}) { |r, v| r.update(v.id => v) }
      children = edges.inject({}) { |r, e| r.update(e.child_id => true) }

      ids.reject { |k, _| children[k] }.map { |_, v| v }
    end
  end
end
