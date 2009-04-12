module Dagnabit
  module Configuration
    module Edge
      DEFAULTS = {
        :ancestor_id_column => 'ancestor_id',
        :descendant_id_column => 'descendant_id',
        :ancestor_type_column => 'ancestor_type',
        :descendant_type_column => 'descendant_type'
      }

      attr_accessor :ancestor_id_column
      attr_accessor :descendant_id_column
      attr_accessor :ancestor_type_column
      attr_accessor :descendant_type_column
      
      def configure_acts_as_dag_edge(options)
        DEFAULTS.merge(options).each do |key, value|
          self.send("#{key}=", value)
        end
      end
    end
  end
end
