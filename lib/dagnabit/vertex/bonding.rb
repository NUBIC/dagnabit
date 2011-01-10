require File.join(File.dirname(__FILE__), %w(.. vertex))

module Dagnabit::Vertex
  ##
  # Contains methods for bonding a vertex to a graph.
  module Bonding
    ##
    # Calculates a bond for this vertex (the method receiver) to all source
    # vertices of `graph`.
    #
    # This method expects the receiver to have been persisted, and will raise
    # `RuntimeError` if that is not the case.
    #
    # Persisted edges that already connect the receiver vertex to source
    # vertices in `graph` will not be duplicated.  Unpersisted edges connecting
    # the receiver to a source in `graph` _will_ be duplicated, so it is
    # advised that you ensure that all vertices and edges in `graph` have been
    # persisted before using {#bond_for}.
    #
    # This method requires the existence of an edge model; see
    # {Settings#edge_model} and {Settings#edge_model_name=}.  If an edge model
    # has not been set, this method raises `RuntimeError`.
    #
    # Edges instantiated by `bond_for` are not automatically saved.
    #
    # @param [Dagnabit::Graph] graph the graph to bond
    # @return [Array<edge_model>] a list of edges that, when saved, will bond the
    #   vertex to `graph`
    # @raise [RuntimeError] if an edge model has not been set
    def bond_for(graph)
      edge = self.class.edge_model

      raise 'edge_model must be set' unless edge
      raise "#{self} must be persisted before invoking bond_for" if new_record?

      sources = graph.sources
      existing = edge.all(:conditions => { :parent_id => id, :child_id => sources.map(&:id) }).map { |e| [e.parent_id, e.child_id] }
      new = sources.inject([]) { |es, s| es << [id, s.id] }

      (new - existing).map { |p, c| edge.new(:parent_id => p, :child_id => c) }
    end
  end
end
