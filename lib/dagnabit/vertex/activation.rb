require File.join(File.dirname(__FILE__), %w(.. vertex))

module Dagnabit::Vertex
  ##
  # This module provides a method to set up all of the Vertex modules in a
  # class.
  module Activation
    ##
    # Sets up dagnabit's vertex modules in a vertex class.
    def acts_as_vertex
      extend Associations
      extend Connectivity
      extend Settings

      include Bonding
      include Neighbors
    end
  end
end
