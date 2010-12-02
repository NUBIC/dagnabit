So I lied
=========

dagnabit is actually still alive.  I still think you should be using something
like Sequel if you really want to do graphs in a SQL database, but if you're
using ActiveRecord for whatever reason, dagnabit might still be useful.

Version 3 is a rework of dagnabit as a PostgreSQL-specific ActiveRecord plugin.
It's blatantly incompatible with the 2.x series of dagnabit.  There are some
migration notes in MIGRATION.md.

dagnabit
========

dagnabit is (yet another) ActiveRecord plugin for directed acyclic graphs.  It
stores directed acyclic graphs as an adjacency list, using recursive common
table expressions to perform fast reachability queries.

dagnabit was developed at the [Northwestern University Biomedical Informatics
Center](http://www.nucats.northwestern.edu/centers/nubic/index.html) for a Ruby
on Rails application designed for management and querying of
large-and-rapidly-growing biospecimen banks (i.e. for cancer research).  The
application uses directed acyclic graphs for knowledge representation (storage
and application of workflows) and representing biospecimen heritage.

dagnabit is hosted at Gitorious and Github:

* <http://gitorious.org/dagnabit/dagnabit>
* <http://github.com/yipdw/dagnabit>

Installation
============

    gem install dagnabit

Related work
============

This plugin was inspired by [Matthew Leventi's acts-as-dag
plugin](http://github.com/mleventi/acts-as-dag/tree/master).  Indeed, Leventi's
acts-as-dag plugin was originally used in the application from which this plugin
was extracted.

The primary differences between dagnabit and acts-as-dag are:

* dagnabit does not maintain a separate transitive closure table, which speeds
  up insertion.

* acts-as-dag does not permit linking of unpersisted nodes, i.e.

      n1 = Vertex.new
      n2 = Vertex.new
      e1 = Edge.new(:parent => n1, :child => n2)
      ... other code ...

      [n1, n2, e1].map { |o| o.save }

  With acts-as-dag, one must save the nodes _before_ creating the edge.
  The above code segment works in dagnabit.

Database compatibility
======================

PostgreSQL.  That's all I know that'll work with dagnabit, anyway.

It's possible other SQL databases will work, but I have no tests to demonstrate
that situation.

Using dagnabit
==============

Database schema
---------------

You'll need at least one table for storing your graph's vertices.  Additionally,
for every vertex table you create, you will need one edge table.

Polymorphic vertices are supported via single table inheritance.

Here's an example schema written as an ActiveRecord schema definition:

    create_table :vertices do |t|
      t.integer :ordinal
      t.string  :type     # only if you're using STI
    end

    create_table :edges do |t|
      t.references :parent, :null => false
      t.references :child,  :null => false
    end

    add_index :edges, [:parent_id, :child_id], :unique => true

Maintaining a directed acyclic simple graph and some words on validation
------------------------------------------------------------------------

dagnabit is designed to operate on directed, acyclic, simple graphs.  That means:

1. each edge has a direction (_directed_),
2. there cannot exist any edges that create a cycle (_acyclic_),
3. any edge must connect two and only two vertices (no _hyperedges_), and
4. there may be only zero or one edges connecting any two vertices (_simple_).

dagnabit is set up to make the database enforce these invariants:

1. The directionality of each edge is implicit in the edge table structure from
   parent to child.
2. dagnabit provides a PL/pgSQL trigger that you can use to abort saving edges
   that, when inserted, causes a cycle.  More on this below.
3. As each edge may only address one parent and one child, the maximum of two
   vertices is guaranteed.  `NOT NULL` constraints on the `parent_id` and
   `child_id` columns guarantee the minimum of two.  (It is recommended that you
   also set up foreign key constraints from edges to vertices, though that
   addresses a different issue.)
4. The `(parent_id, child_id)` index prevents multiple edges connecting the same
   vertices.

You may, of course, relax invariants 2-4 by omitting indices or constraints;
however, if you do that, you risk problems such as
{Dagnabit::Vertex::Connectivity} methods generating infinite loops.

Note that dagnabit currently does not provide a way to catch data that would
violate these invariants via ActiveRecord's validation subsystem.  Violations,
therefore, will result in quite nasty (from the ActiveRecord perspective of
things) `PGError`s.

If you design your application code such that these invariants cannot be
violated via typical user actions, then this is probably fine, because in that
case the `PGError` exception (which, in this case, you probably don't want to
handle) indicates either the existence of an error in the code and/or malicious
activity that was prevented.

On the other hand, if users of your application will be building dags as part of
their interactions with your application, then it is a very real possibility
that violation of the above invarints may occur in the course of normal user
activity.  In this case, you must trap these errors and provide adequate
feedback to your users so that they can correct the problem.  This, like many UI
problems, is not a trivial problem to solve, and I do not have any general
solution for it.

dagnabit's cycle-checking trigger
---------------------------------

dagnabit ships with a PL/pgSQL trigger that can be installed on edge tables.
The trigger algorithm is run per inserted or updated row, and may be described
as

    trigger check_cycle(seen = [], edge = (a, b)):
      if a != b
        if b has no children
          ok
        else
          for each child c of b
            check_cycle(seen + [b], (a, c))
        end
      else
        abort
      end

The implementation uses a `WITH RECURSIVE` query.

The {Dagnabit::Migration} module provides methods for creating and dropping
triggers on edge tables:

    class CreateEdges < ActiveRecord::Migration
      extend Dagnabit::Migration

      def self.up
        create_table :edges do |t|
          ...
        end

        create_cycle_check_trigger :edges
      end

      def self.down
        drop_cycle_check_trigger :edges

        drop_table :edges
      end
    end

Using dagnabit in your application
----------------------------------

dagnabit is activated on vertex and edge models by extending vertex and edge
classes with {Dagnabit::Vertex::Activation} and {Dagnabit::Edge::Activation},
respectively:

    class Vertex < ActiveRecord::Base
      extend Dagnabit::Vertex::Activation

      acts_as_vertex
    end

    class Edge < ActiveRecord::Base
      extend Dagnabit::Edge::Activation

      acts_as_edge
    end

By default, the vertex connectivity queries expect the edge table to be called
"edges", but that is by no means required.  Just associate the vertex with a
different edge model:

    class OtherVertex < ActiveRecord::Base
      extend Dagnabit::Vertex::Activation

      acts_as_vertex
      connected_by 'OtherEdge'
    end

You may find it helpful to have parent and child associations on the edge model.
These can either be written by you, or you can let dagnabit do it:

    class Edge < ActiveRecord::Base
      extend Dagnabit::Edge::Activation

      acts_as_edge
      connects 'Vertex'     # sets up belongs_to associations called "parent"
                            # and "child"
    end

For further information, see the library API documentation.  Also see the
listing of the `dagnabit-test` program.

Copyright
=========

Copyright (c) 2009, 2010 David Yip.  Released under the MIT License; see
LICENSE for details.
