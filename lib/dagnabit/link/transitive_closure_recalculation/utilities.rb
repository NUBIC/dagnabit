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

        def all_quoted_column_values
          all_column_names.map { |n| connection.quote(send(n)) }
        end

        def all_quoted_column_names
          all_column_names.map { |n| connection.quote_column_name(n) }
        end

        def all_column_names
          all_columns.map { |c| c.name }
        end

        def with_temporary_edge_tables(*tables, &block)
          tables.each do |table|
            connection.create_table(table, :temporary => true, :id => false) do |t|
              all_columns.each do |c|
                t.send(c.type, c.name)
              end
            end
          end

          yield(tables.map { |t| connection.quote_table_name(t) })

          tables.each do |table|
            connection.drop_table table
          end
        end

        def all_columns
          self.class.columns.reject { |c| c.name == 'id' || c.name == 'type' }
        end
      end
    end
  end
end
