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
              INSERT INTO #{suspect} (#{tc_aid}, #{tc_did}, #{tc_atype}, #{tc_dtype})
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
              INSERT INTO #{trusty} (#{tc_aid}, #{tc_did}, #{tc_atype}, #{tc_dtype})
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
                            SUSPECT.#{tc_aid} = TC.#{tc_aid} AND SUSPECT.#{tc_did} = TC.#{tc_did}
                            AND
                            SUSPECT.#{tc_atype} = TC.#{tc_atype} AND SUSPECT.#{tc_dtype} = TC.#{tc_dtype}
                      )
                  UNION
                  SELECT
                    #{my_aid}, #{my_did}, #{my_atype}, #{my_dtype}
                    FROM
                      #{my_table} AS G
                    WHERE
                      NOT (G.#{my_aid} = #{aid} AND g.#{my_atype} = #{atype}
                           AND
                           G.#{my_did} = #{did} AND g.#{my_dtype} = #{dtype})
                ) AS tmp0
            END

            connection.execute <<-END
              INSERT INTO #{new} (#{tc_aid}, #{tc_did}, #{tc_atype}, #{tc_dtype})
                SELECT * FROM (
                  SELECT #{tc_aid}, #{tc_did}, #{tc_atype}, #{tc_dtype} FROM #{trusty}
                  UNION
                  SELECT
                    T1.#{tc_aid}, T2.#{tc_aid}, T1.#{tc_atype}, T2.#{tc_dtype}
                    FROM
                      #{trusty} T1, #{trusty} T2
                    WHERE
                      T1.#{tc_aid} = T2.#{tc_aid} AND T1.#{tc_atype} = T2.#{tc_dtype}
                  UNION
                  SELECT
                    T1.#{tc_aid}, T3.#{tc_aid}, T1.#{tc_atype}, T3.#{tc_dtype}
                    FROM
                      #{trusty} T1, #{trusty} T2, #{trusty} T3
                    WHERE
                      T1.#{tc_aid} = T2.#{tc_aid} AND T2.#{tc_aid} = T3.#{tc_aid}
                      AND
                      T1.#{tc_dtype} = T2.#{tc_atype} AND T2.#{tc_dtype} = T3.#{tc_atype}
                ) AS tmp0
            END

            connection.execute <<-END
              DELETE FROM #{tc} WHERE NOT EXISTS (
                SELECT *
                  FROM
                    #{new} T
                  WHERE
                    T.#{tc_aid} = #{tc}.#{tc_aid} AND T.#{tc_did} = #{tc}.#{tc_did}
                    AND
                    T.#{tc_atype} = #{tc}.#{tc_atype} AND T.#{tc_dtype} = #{tc}.#{tc_dtype}
              )
            END
          end
        end
      end
    end
  end
end
