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
        paths(a, b).length > 0
      end

      def paths(a, b)
        transitive_closure_class.linking(a, b)
      end
    end
  end
end
