require File.join(File.dirname(__FILE__), %w(.. vertex))

module Dagnabit::Vertex
  ##
  # Contains methods for bonding a vertex to a graph.
  module Bonding
    ##
    # Calculates a bond for this vertex (the method receiver) to all source
    # vertices of `graph`.  Edges that already connect the receiver vertex to
    # source vertices in `graph` will not be duplicated.
    #
    # This method requires the existence of an edge model; see
    # {Settings#edge_model} and {Settings#set_edge_model}.  If an edge model has
    # not been set, this method raises `RuntimeError`.
    #
    # Put another way, `bond_for` creates an edge cut set between the null
    # graph containing the receiver vertex and `graph`.
    #
    # Edges instantiated by `bond_for` are not automatically saved.
    #
    # @param [Dagnabit::Graph] graph the graph to bond
    # @return [Array<edge_model>] a list of edges that, when saved, will bond the
    #   vertex to `graph`
    # @raise [RuntimeError] if an edge model has not been set
    def bond_for(graph)
      raise 'edge_model must be set' unless self.class.edge_model

      graph.sources.inject([]) do |edges, source|
        edges << self.class.edge_model.new(:parent => self, :child => source)
      end
    end
  end
end
