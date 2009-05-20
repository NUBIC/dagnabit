module Dagnabit
  module Link
    module TransitiveClosureRecalculation
      module OnDestroy
        def after_destroy
          super
          update_transitive_closure_for_destroy(*quoted_dag_link_values)
        end

        private

        def update_transitive_closure_for_destroy(aid, did, atype, dtype)
          my_table = self.class.quoted_table_name
          my_aid, my_did, my_atype, my_dtype = quoted_dag_link_column_names
          tc = self.class.transitive_closure_table_name
          tc_aid, tc_did, tc_atype, tc_dtype = quoted_dag_link_column_names

          with_temporary_edge_tables('suspect', 'trusty', 'new') do |suspect, trusty, new|
            connection.execute <<-END
              INSERT INTO #{suspect} 
                SELECT * FROM (
                  SELECT
                    TC1.#{tc_aid}, TC2.#{tc_did}, TC1.#{tc_atype}, TC2.#{tc_dtype}
                    FROM
                      #{tc} AS TC1, #{tc} AS TC2
                    WHERE
                      TC1.#{tc_did} = #{aid} AND TC2.#{tc_aid} = #{did}
                      AND
                      TC1.#{tc_dtype} = #{atype} AND TC2.#{tc_atype} = #{dtype}
                  UNION
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
                      #{aid}, #{did}, #{atype}, #{dtype}
                      FROM
                        #{tc} AS TC
                      WHERE
                        TC.#{tc_aid} = #{aid} AND TC.#{tc_did} = #{did}
                        AND
                        TC.#{tc_atype} = #{atype} AND TC.#{tc_dtype} = #{dtype}
                ) AS tmp0
            END

            connection.execute <<-END
              INSERT INTO #{trusty}
                SELECT
                  #{tc_aid}, #{tc_did}, #{tc_atype}, #{tc_dtype}
                  FROM (
                    SELECT
                      #{tc_aid}, #{tc_did}, #{tc_atype}, #{tc_dtype}
                      FROM
                        #{tc} AS TC
                      WHERE NOT EXISTS (
                        SELECT *
                          FROM
                            #{suspect} AS SUSPECT
                          WHERE
                            SUSPECT.ancestor_id = TC.#{tc_aid} AND SUSPECT.descendant_id = TC.#{tc_did}
                            AND
                            SUSPECT.ancestor_type = TC.#{tc_atype} AND SUSPECT.descendant_type = TC.#{tc_dtype}
                      )
                  UNION
                  SELECT
                    #{my_aid}, #{my_did}, #{my_atype}, #{my_dtype}
                    FROM
                      #{my_table} AS G
                    WHERE
                      G.#{my_aid} <> #{aid} AND G.#{my_did} <> #{did}
                      AND
                      G.#{my_atype} <> #{atype} AND G.#{my_dtype} <> #{dtype}
                ) AS tmp0
            END

            connection.execute <<-END
              INSERT INTO #{new}
                SELECT * FROM (
                  SELECT * FROM #{trusty}
                  UNION
                  SELECT
                    T1.ancestor_id, T2.descendant_id, T1.ancestor_type, T2.descendant_type
                    FROM
                      #{trusty} T1, #{trusty} T2
                    WHERE
                      T1.ancestor_id = T2.descendant_id AND T1.ancestor_type = T2.descendant_type
                  UNION
                  SELECT
                    T1.ancestor_id, T3.descendant_id, T1.ancestor_type, T3.descendant_type
                    FROM
                      #{trusty} T1, #{trusty} T2, #{trusty} T3
                    WHERE
                      T1.descendant_id = T2.ancestor_id AND T2.descendant_id = T3.ancestor_id
                      AND
                      T1.descendant_type = T2.ancestor_type AND T2.descendant_type = T3.ancestor_type
                ) AS tmp0
            END

            connection.execute <<-END
              DELETE FROM #{tc} WHERE NOT EXISTS (
                SELECT *
                  FROM
                    #{new} T
                  WHERE
                    T.ancestor_id = #{tc}.#{tc_aid} AND T.descendant_id = #{tc}.#{tc_did}
                    AND
                    T.ancestor_type = #{tc}.#{tc_atype} AND T.descendant_type = #{tc}.#{tc_dtype}
              )
            END
          end
        end
      end
    end
  end
end
