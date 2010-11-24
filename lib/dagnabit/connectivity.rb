require File.join(File.dirname(__FILE__), %w(.. dagnabit))

module Dagnabit
  ##
  # Methods for checking connectivity between vertices.
  #
  # This module is meant to be used by ActiveRecord::Base subclasses.
  module Connectivity
    ##
    # Finds all source vertices of the given `vertices`.  A source vertex is a
    # vertex that has an indegree of zero.
    #
    # The result is the set union of all source vertices of the vertices in
    # `vertices`.  The ordering of the result is unspecified.
    #
    # @param [Array<ActiveRecord::Base>] vertices a list of vertices
    # @return [Array<ActiveRecord::Base>] a list of source vertices
    def roots_of(*vertices)
      ids = vertices.map(&:id)

      find_by_sql([%Q{
        WITH RECURSIVE roots(id) AS (
          SELECT edges.parent_id FROM #{table_name} INNER JOIN edges ON edges.child_id = #{table_name}.id WHERE #{table_name}.id IN (?)
          UNION
          SELECT edges.parent_id FROM roots INNER JOIN edges ON edges.child_id = roots.id
        )
        SELECT
          *
        FROM
          #{table_name}
        WHERE
          #{table_name}.id IN (SELECT
                                roots.id
                               FROM
                                roots
                                LEFT JOIN
                                edges ON roots.id = edges.child_id
                               WHERE edges.child_id IS NULL)
      }, ids])
    end

    ##
    # Find all ancestors of the given `vertices`.
    #
    # The result is the set union of all ancestors of the vertices in
    # `vertices`.  The ordering of the result is unspecified.
    #
    # @param [Array<ActiveRecord::Base>] vertices a list of vertices
    # @return [Array<ActiveRecord::Base>] a list of ancestor vertices
    def ancestors_of(*vertices)
      ids = vertices.map(&:id)

      find_by_sql([%Q{
        WITH RECURSIVE ancestors(id) AS (
          SELECT edges.parent_id FROM #{table_name} INNER JOIN edges ON edges.child_id = #{table_name}.id WHERE #{table_name}.id IN (?)
          UNION
          SELECT edges.parent_id FROM ancestors INNER JOIN edges ON edges.child_id = ancestors.id
        )
        SELECT * FROM #{table_name} WHERE #{table_name}.id IN (SELECT id FROM ancestors)
      }, ids])
    end

    ##
    # Finds all immediate parents of `vertices`.
    #
    # The result is the set union of all immediate parents of the vertices in
    # `vertices`.  The ordering of the result is unspecified.
    #
    # @param [Array<ActiveRecord::Base>] vertices a list of vertices
    # @return [Array<ActiveRecord::Base>] a list of parent vertices
    def parents_of(*vertices)
      ids = vertices.map(&:id)

      find_by_sql([%Q{
        SELECT
          *
        FROM
          #{table_name}
        WHERE
          #{table_name}.id IN
            (SELECT parent_id FROM edges WHERE child_id IN (?))
      }, ids])
    end

    ##
    # Finds all immediate children of `vertices`.
    #
    # The result is the set union of all immediate children of the vertices in
    # `vertices`.  The ordering of the result is unspecified.
    #
    # @param [Array<ActiveRecord::Base>] vertices a list of vertices
    # @return [Array<ActiveRecord::Base>] a list of child vertices
    def children_of(*vertices)
      ids = vertices.map(&:id)

      find_by_sql([%Q{
        SELECT
          *
        FROM
          #{table_name}
        WHERE
          #{table_name}.id IN
            (SELECT child_id FROM edges WHERE parent_id IN (?))
      }, ids])
    end

    ##
    # Find all descendants of the given `vertices`.
    #
    # The result is the set union of all descendants of the vertices in
    # `vertices`.  The ordering of the result is unspecified.
    #
    # @param [Array<ActiveRecord::Base>] vertices a list of vertices
    # @return [Array<ActiveRecord::Base>] a list of descendant vertices
    def descendants_of(*vertices)
      ids = vertices.map(&:id)

      find_by_sql([%Q{
        WITH RECURSIVE descendants(id) AS (
          SELECT edges.child_id FROM #{table_name} INNER JOIN edges ON edges.parent_id = #{table_name}.id WHERE #{table_name}.id IN (?)
          UNION
          SELECT edges.child_id FROM descendants INNER JOIN edges ON edges.parent_id = descendants.id
        )
        SELECT * FROM #{table_name} WHERE #{table_name}.id IN (SELECT id FROM descendants)
      }, ids])
    end
  end
end
