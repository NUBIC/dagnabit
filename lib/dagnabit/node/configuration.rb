module Dagnabit
  module Node
    #
    # Configuration mechanism for nodes in a dagnabit-managed dag.
    #
    module Configuration
      #
      # The name of the model used to link nodes of this class.
      # 
      attr_accessor :link_class_name

      attr_accessor :neighbor_node_class_names

      #
      # Configure node behavior.
      #
      def configure_acts_as_dag_node(link_class_name, options = {})
        self.link_class_name = link_class_name
        self.neighbor_node_class_names = options[:neighbor_node_class_names] || []
      end
    end
  end
end
