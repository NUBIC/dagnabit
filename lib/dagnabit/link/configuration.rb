module Dagnabit
  module Link
    #
    # Dagnabit::Edge::Configuration - dag edge configuration
    #
    module Configuration
      attr_accessor :ancestor_id_column
      attr_accessor :descendant_id_column
      attr_accessor :ancestor_type_column
      attr_accessor :descendant_type_column
      attr_accessor :transitive_closure_table_name
      
      def configure_acts_as_dag_link(options)
        self.ancestor_id_column = options[:ancestor_id_column] || 'ancestor_id'
        self.descendant_id_column = options[:descendant_id_column] || 'descendant_id'
        self.ancestor_type_column = options[:ancestor_type_column] || 'ancestor_type'
        self.descendant_type_column = options[:descendant_type_column] || 'descendant_type'
        self.transitive_closure_table_name = options[:transitive_closure_table_name] || table_name + '_transitive_closure_tuples'
      end
    end
  end
end
