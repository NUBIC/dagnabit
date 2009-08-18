module Dagnabit
  module Link
    #
    # Handy class methods for creating and querying paths.
    #
    module ClassMethods
      #
      # Constructs a new edge.  The direction of the edge runs from +from+ to +to+.
      #
      def build_edge(from, to, attributes = {})
        new(attributes.merge(:ancestor => from, :descendant => to))
      end

      #
      # Like +build_edge+, but saves the edge after it is instantiated.
      # Returns true if the endpoints could be connected, false otherwise.
      #
      # See Dagnabit::Link::Validations for more information on built-in link
      # validations.
      #
      def connect(from, to, attributes = {})
        build_edge(from, to, attributes).save
      end

      # 
      # Returns true if there is a path from +a+ to +b+, false otherwise.
      # 
      def path?(a, b)
        paths(a, b).length > 0
      end

      #
      # Returns all paths from +a+ to +b+.
      #
      # These paths are returned as transitive closure links, which aren't
      # guaranteed to have the same methods as your link class.
      #
      def paths(a, b)
        transitive_closure_class.linking(a, b)
      end
    end
  end
end
