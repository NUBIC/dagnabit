require File.join(File.dirname(__FILE__), %w(.. edge))

module Dagnabit::Edge
  ##
  # This module provides a method to set up all of the Edge modules in a class.
  module Activation
    ##
    # Sets up dagnabit's edge modules in an edge class.
    def acts_as_edge
      extend Associations
      extend Connectivity
    end
  end
end
