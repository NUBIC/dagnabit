require File.join(File.dirname(__FILE__), %w(.. edge))

module Dagnabit::Edge
  ##
  # Methods for querying connectivity of edges.
  module Connectivity
    ##
    # Finds all edges connecting the given vertices.
    #
    # More specifically, finds all edges such that the edge's parent and child
    # is one of the given vertices.
    #
    # This means that should vertices belong to disjoint subgraphs be selected,
    # e.g.
    #
    #     (a)  (d)
    #      |    |
    #     (b)   e
    #      |    |
    #     (c)   f
    #
    # where () denotes a selected vertex, then only the edges for which both
    # the parent and child vertices are present will be in the result set.  In
    # the above example, this means that while the a->b and b->c edges will be
    # present, the d->e edge will not.  To include the d->e edge, e would have
    # to be in the vertex list.
    #
    # @param [Array<ActiveRecord::Base>] vertices the vertices to consider
    # @return [Array<ActiveRecord::Base>] a list of edges
    def connecting(*vertices)
      ids = vertices.map(&:id)

      find_by_sql([%Q{
        SELECT * FROM #{table_name} WHERE parent_id IN (:ids) AND child_id IN (:ids)
      }, { :ids => ids }])
    end
  end
end
