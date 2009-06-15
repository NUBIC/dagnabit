require 'dagnabit/link/transitive_closure_recalculation/utilities'

module Dagnabit
  module Link
    module TransitiveClosureRecalculation
      module OnCreate
        include Utilities

        def after_create
          super
          update_transitive_closure_for_create
        end

        private

        def update_transitive_closure_for_create
          tc = self.class.transitive_closure_table_name
          tc_aid, tc_did, tc_atype, tc_dtype = quoted_dag_link_column_names
          aid, did, atype, dtype = quoted_dag_link_values
          all_columns = all_quoted_column_names.join(',')
          all_values = all_quoted_column_values.join(',')

          with_temporary_edge_tables('new', 'delta') do |new, delta|
            extend_connected_paths(new, tc_aid, tc_did, tc_atype, tc_dtype, tc, aid, did, atype, dtype)
            append_created_edge(new, all_columns, all_values)
            synchronize_transitive_closure(new, delta, all_columns, tc, tc_aid, tc_did, tc_atype, tc_dtype)
          end
        end

        #
        # determine:
        # * all paths constructed by adding (a, b) to the back of paths
        #   ending at a (first subselect)
        # * all paths constructed by adding (a, b) to the front of paths
        #   starting at b (second subselect)
        # * all paths constructed by adding (a, b) in the middle of paths
        #   starting at a and ending at b (third subselect)
        #
        def extend_connected_paths(new, tc_aid, tc_did, tc_atype, tc_dtype, tc, aid, did, atype, dtype)
          connection.execute <<-END
            INSERT INTO #{new} (#{tc_aid}, #{tc_did}, #{tc_atype}, #{tc_dtype})
              SELECT * FROM (
                SELECT
                  TC.#{tc_aid}, #{did}, TC.#{tc_atype}, #{dtype}
                  FROM
                    #{tc} AS TC
                  WHERE
                    TC.#{tc_did} = #{aid} AND TC.#{tc_dtype} = #{atype}
                UNION
                SELECT
                  #{aid}, TC.#{tc_did}, #{atype}, TC.#{tc_dtype}
                  FROM
                    #{tc} AS TC
                  WHERE
                    TC.#{tc_aid} = #{did} AND TC.#{tc_atype} = #{dtype}
                UNION
                SELECT
                  TC1.#{tc_aid}, TC2.#{tc_did}, TC1.#{tc_atype}, TC2.#{tc_dtype}
                  FROM
                    #{tc} AS TC1, #{tc} AS TC2
                  WHERE
                    TC1.#{tc_did} = #{aid} AND TC1.#{tc_dtype} = #{atype}
                    AND
                    TC2.#{tc_aid} = #{did} AND TC2.#{tc_atype} = #{dtype}
              ) AS tmp0
          END
        end

        def append_created_edge(new, all_columns, all_values)
          connection.execute <<-END
            INSERT INTO #{new} (#{all_columns}) VALUES (#{all_values})
          END
        end

        def synchronize_transitive_closure(new, delta, all_columns, tc, tc_aid, tc_did, tc_atype, tc_dtype)
          #
          # ...filter out duplicates...
          #
          connection.execute <<-END
            INSERT INTO #{delta}
            SELECT * FROM #{new} AS T
              WHERE NOT EXISTS (
                SELECT *
                  FROM
                    #{tc} AS TC
                  WHERE
                    TC.#{tc_aid} = T.#{tc_aid} AND TC.#{tc_did} = T.#{tc_did}
                    AND
                    TC.#{tc_atype} = T.#{tc_atype} AND TC.#{tc_dtype} = T.#{tc_dtype}
              )
          END

          #
          # ...and update the transitive closure table
          #
          connection.execute <<-END
            INSERT INTO #{tc} (#{all_columns})
              SELECT * FROM #{delta}
          END
        end
      end
    end
  end
end
