Migrating from Dagnabit 2 to Dagnabit 3
=======================================

1. Polymorphic associations are no longer supported.  If you need a polymorphic
   graph, convert your data model to use single-table inheritance.

2. The `*_transitive_closure` tables are no longer used, and can be dropped.

3. Dagnabit is no longer mixed into `ActiveRecord::Base` by default.  You need
   to augment the models you want to use as vertices:

      class Vertex < ActiveRecord::Base
        extend Dagnabit::Vertex::Connectivity
      end

   If you want the instance method connectivity queries, those are in a
   separate module:

      class Vertex < ActiveRecord::Base
        extend Dagnabit::Vertex::Connectivity
        include Dagnabit::Vertex::Neighbors
      end

4. The default name of the edge table is now `edges`.  The name of the vertex table
   is now taken from the model(s) in which Dagnabit is mixed in.

   So, for example, if you had the following models:

        class Vertex < ActiveRecord::Base
        end

        class BetaVertex < Vertex
        end

        class DifferentGraphVertex < ActiveRecord::Base
          set_edge_table 'different_edges'
        end

    then `Vertex` and `BetaVertex` would be stored in the `vertices` table and use
    the `edges` table, and `DifferentGraphVertex` instances would be created from rows
    in the `different_graph_vertices` table and be linked with edges from the
    `different_edges` table.

5.  The default edge column names have changed.  `ancestor_id` is now `parent_id`
    and `descendant_id` is now `child_id`.  `ancestor_type` and `descendant_type`
    are now unused.

6.  Technically, you no longer need an edge model to use Dagnabit.  It can,
    however, occasionally be useful.  To make an edge model, create a model
    resembling

        class Edge < ActiveRecord::Base
        end

    To use the edge connectivity methods:

        class Edge < ActiveRecord::Base
          extend Dagnabit::Edge::Connectivity
        end

 :vim:tw=80
