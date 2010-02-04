module Dagnabit
  module Link
    module TransitiveClosureRecalculation
      module OnUpdate
        def after_update
          current_values = dag_link_column_names.map { |n| connection.quote(send(n)) }
          old_values = dag_link_column_names.map { |n| connection.quote(changes[n].try(:first) || send(n)) }

          return unless current_values != old_values

          update_transitive_closure_for_destroy(*old_values)
          update_transitive_closure_for_create
        end
      end
    end
  end
end
