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

          with_temporary_edge_tables('new', 'delta') do |new, delta|
            connection.execute <<-END
              INSERT INTO #{new} (ancestor_id, descendant_id, ancestor_type, descendant_type)
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
                )
            END

            connection.execute <<-END
              INSERT INTO #{new} VALUES (#{aid}, #{did}, #{atype}, #{dtype})
            END

            connection.execute <<-END
              INSERT INTO #{delta} (ancestor_id, descendant_id, ancestor_type, descendant_type)
              SELECT * FROM #{new} AS T
                WHERE NOT EXISTS (
                  SELECT *
                    FROM
                      #{tc} AS TC
                    WHERE
                      TC.#{tc_aid} = T.ancestor_id AND TC.#{tc_did} = T.descendant_id
                      AND
                      TC.#{tc_atype} = T.ancestor_type AND TC.#{tc_dtype} = T.descendant_type
                )
            END

            connection.execute <<-END
              INSERT INTO #{tc} (#{tc_aid}, #{tc_did}, #{tc_atype}, #{tc_dtype})
                SELECT * FROM #{delta}
            END
          end
        end
      end
    end
  end
end
