module Dagnabit
  module Link
    module TransitiveClosureLinkModel
      attr_reader :transitive_closure_class

      private

      def generate_transitive_closure_link_model(options)
        original_class = self

        klass = Class.new(ActiveRecord::Base) do
          extend Dagnabit::Link::Configuration
          configure_acts_as_dag_link(options)
          set_table_name original_class.unquoted_transitive_closure_table_name

          def self.linking(from, to)
            find(:all, :conditions => {
                          ancestor_id_column => from.id,
                          ancestor_type_column => from.class.name,
                          descendant_id_column => to.id,
                          descendant_type_column => to.class.name
                        })
          end
        end

        @transitive_closure_class = const_set(transitive_closure_class_name, klass)

        # reflections aren't properly created in anonymous models, so
        # associations need to be created after the model has been named
        @transitive_closure_class.extend(Dagnabit::Link::Associations)
      end
    end
  end
end
