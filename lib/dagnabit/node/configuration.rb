module Dagnabit
  module Node
    module Configuration
      attr_accessor :link_class_name

      def configure_acts_as_dag_node(link_class_name, options = {})
        self.link_class_name = link_class_name
      end
    end
  end
end
