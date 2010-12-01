Migrating from dagnabit 2 to dagnabit 3
=======================================

1. Polymorphic associations are no longer supported.  If you need a polymorphic
   graph, convert your data model to use single-table inheritance.

2. The `*_transitive_closure` tables are no longer used, and can be dropped.

3. dagnabit is no longer mixed into `ActiveRecord::Base` by default.  You need
   to augment the models you want to use as vertices:

        class Vertex < ActiveRecord::Base
          extend Dagnabit::Vertex::Activation

          acts_as_vertex
        end

4. The default name of the edge table is now `edges`, and the name of the vertex
   table is taken from the model.

   So, for example, if you had the following models:

        class Vertex < ActiveRecord::Base
          extend Dagnabit::Vertex::Activation

          acts_as_vertex
        end

        class BetaVertex < Vertex
        end

        class DifferentGraphVertex < ActiveRecord::Base
          extend Dagnabit::Vertex::Activation

          acts_as_vertex
          set_edge_table 'different_edges'
        end

    then `Vertex` and `BetaVertex` would be stored in the `vertices` table and use
    the `edges` table, and `DifferentGraphVertex` instances would be created from rows
    in the `different_graph_vertices` table and be linked with edges from the
    `different_edges` table.

5.  The default edge column names have changed.  `ancestor_id` is now `parent_id`
    and `descendant_id` is now `child_id`.  `ancestor_type` and `descendant_type`
    are now unused.

6.  Technically, you no longer need an edge model to use dagnabit.  It can,
    however, occasionally be useful.  To make an edge model, create a model
    resembling

        class Edge < ActiveRecord::Base
          extend Dagnabit::Edge::Activation

          acts_as_edge
        end
