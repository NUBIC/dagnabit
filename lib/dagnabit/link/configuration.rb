module Dagnabit
  module Link
    #
    # Dagnabit::Edge::Configuration - dag edge configuration
    #
    module Configuration
      attr_accessor :ancestor_id_column
      attr_accessor :descendant_id_column
      attr_writer :transitive_closure_table_name
      
      def configure_acts_as_dag_link(options)
        self.ancestor_id_column = options[:ancestor_id_column] || 'ancestor_id'
        self.descendant_id_column = options[:descendant_id_column] || 'descendant_id'
        self.transitive_closure_table_name = options[:transitive_closure_table_name] || table_name + '_transitive_closure_tuples'
      end

      def transitive_closure_table_name
        connection.quote_table_name(@transitive_closure_table_name)
      end
    end
  end
end
