require File.join(File.dirname(__FILE__), %w(.. vertex))

module Dagnabit::Vertex
  ##
  # Provides per-vertex connectivity queries.
  #
  # This module should be included into a class that has been extended by
  # {Dagnabit::Vertex::Connectivity}.  See this module's spec for example usage.
  module Neighbors
    ##
    # Finds all source vertices of the receiver object.
    #
    # @return [Array<ActiveRecord::Base>] a list of source vertices
    def roots
      self.class.roots_of(self)
    end

    ##
    # Finds all ancestors of the receiver object.
    #
    # @return [Array<ActiveRecord::Base>] a list of ancestor vertices
    def ancestors
      self.class.ancestors_of(self)
    end

    ##
    # Finds all parents of the receiver object.
    #
    # @return [Array<ActiveRecord::Base>] a list of parent vertices
    def parents
      self.class.parents_of(self)
    end

    ##
    # Finds all children of the receiver object.
    #
    # @return [Array<ActiveRecord::Base>] a list of child vertices
    def children
      self.class.children_of(self)
    end

    ##
    # Finds all descendants of the receiver object.
    #
    # @return [Array<ActiveRecord::Base>] a list of descendant vertices
    def descendants
      self.class.descendants_of(self)
    end
  end
end
