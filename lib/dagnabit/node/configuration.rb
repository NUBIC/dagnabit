module Dagnabit
  module Node
    #
    # Configuration mechanism for nodes in a dagnabit-managed dag.
    #
    module Configuration
      #
      # Writes accessors for configuration data into a node.
      #
      # The following accessors are available:
      # [link_class_name]
      #   The name of the model used to link nodes of this class.
      #
      def self.extended(base)
        base.class_inheritable_accessor :link_class_name
      end

      #
      # Configure node behavior.
      #
      def configure_acts_as_dag_node(link_class_name)
        self.link_class_name = link_class_name
      end
    end
  end
end
