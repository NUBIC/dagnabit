module Dagnabit
  module Link
    module ClassMethods
      def connect(from, to)
        build_edge(from, to).save
      end

      def build_edge(from, to)
        new(:ancestor => from, :descendant => to)
      end

      def path?(a, b)
      end

      def paths(a, b)
      end
    end
  end
end
