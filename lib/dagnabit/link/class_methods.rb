module Dagnabit
  module Link
    #
    # Handy class methods for creating and querying paths.
    #
    module ClassMethods
      #
      # Constructs a new edge.  The direction of the edge runs from +from+ to +to+.
      #
      def build_edge(from, to)
        new(:ancestor => from, :descendant => to)
      end

      #
      # Like +build_edge+, but saves the edge after it is instantiated.
      #
      def connect(from, to)
        build_edge(from, to).save
      end

      # 
      # Returns true if there is a path from +a+ to +b+, false otherwise.
      # 
      def path?(a, b)
        paths(a, b).length > 0
      end

      def paths(a, b)
        transitive_closure_class.linking(a, b)
      end
    end
  end
end
