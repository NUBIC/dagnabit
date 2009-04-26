module Dagnabit
  module Link
    #
    # Dagnabit::Edge::Configuration - dag edge configuration
    #
    module Configuration
      attr_accessor :ancestor_id_column
      attr_accessor :descendant_id_column
      attr_writer :transitive_closure_table_name
      attr_accessor :transitive_closure_class_name

      #
      # Configure an ActiveRecord model as a dag link. See Dagnabit::Activation
      # for options description.
      #
      def configure_acts_as_dag_link(options)
        self.ancestor_id_column = options[:ancestor_id_column] || 'ancestor_id'
        self.descendant_id_column = options[:descendant_id_column] || 'descendant_id'
        self.transitive_closure_table_name = options[:transitive_closure_table_name] || table_name + '_tc_tuples'
        self.transitive_closure_class_name = options[:transitive_closure_class_name] || 'TransitiveClosureLink'
      end

      def transitive_closure_table_name
        connection.quote_table_name(unquoted_transitive_closure_table_name)
      end

      def unquoted_transitive_closure_table_name
        @transitive_closure_table_name
      end

      def ancestor_type_column
        :ancestor_type
      end

      def descendant_type_column
        :descendant_type
      end
    end
  end
end
