module Dagnabit
  module Link
    module TransitiveClosureRecalculation
      module Utilities
        private

        def quoted_dag_link_values
          dag_link_column_names.map { |n| connection.quote(send(n)) }
        end

        def quoted_dag_link_column_names
          dag_link_column_names.map { |n| connection.quote_column_name(n) }
        end
        
        def dag_link_column_names
          [ self.class.ancestor_id_column,
            self.class.descendant_id_column,
            self.class.ancestor_type_column,
            self.class.descendant_type_column ]
        end

        def with_temporary_edge_tables(*tables, &block)
          tables.each do |table|
            connection.create_table(table, :temporary => true, :id => false) do |t|
              t.integer :ancestor_id
              t.integer :descendant_id
              t.string :ancestor_type
              t.string :descendant_type
            end
          end

          yield(tables.map { |t| connection.quote_table_name(t) })

          tables.each do |table|
            connection.drop_table table
          end
        end
      end
    end
  end
end
