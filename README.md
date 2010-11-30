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

dagnabit was developed at the Northwestern University Biomedical Informatics
Center <http://www.nucats.northwestern.edu/centers/nubic/index.html> for a Ruby
on Rails application designed for management and querying of
large-and-rapidly-growing biospecimen banks (i.e. for cancer research).  The
application uses directed acyclic graphs for knowledge representation (storage
and application of workflows) and representing biospecimen heritage.

dagnabit is hosted at Gitorious and Github:

* http://gitorious.org/dagnabit/dagnabit
* http://github.com/yipdw/dagnabit

Related work
============

This plugin was inspired by Matthew Leventi's acts-as-dag plugin
<http://github.com/mleventi/acts-as-dag/tree/master>.  Indeed, Leventi's
acts-as-dag plugin was originally used in the application from which this
plugin was extracted.

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

Setup
=====

dagnabit is distributed as a gem plugin; you can therefore install it as you
would any other RubyGem.  Integration with your Rails application can be
achieved by adding dagnabit to your application's gem dependencies list.

Database schema
---------------

You'll need at least one table for storing your graph's vertices.  Additionally,
for every vertex table you create, you will need one edge table.

Polymorphic vertices are supported via single table inheritance.

Here's an example schema written as an ActiveRecord schema definition:

    create_table :vertices do |t|
      t.integer :ordinal
      t.string  :type
    end
    
    create_table :edges do |t|
      t.integer :parent_id
      t.integer :child_id
    end

Using dagnabit
==============

dagnabit is activated on vertex and edge models by extending vertex and edge
classes with Dagnabit::Vertex::Connectivity and Dagnabit::Edge::Connectivity,
respectively:

    class Vertex < ActiveRecord::Base
      extend Dagnabit::Vertex::Connectivity
    end

    class Edge < ActiveRecord::Base
      extend Dagnabit::Edge::Connectivity
    end

By default, the vertex connectivity queries expect the edge table to be called
"edges", but that is by no means required:

    class OtherVertex < ActiveRecord::Base
      extend Dagnabit::Vertex::Connectivity
      set_edge_table 'other_edges'
    end

Some of dagnabit's features, such as Dagnabit::Vertex::Bonding, make use of
parent and child associations on the edge model.  These can either be written
by you, or you can let dagnabit do it:

    class Edge < ActiveRecord::Base
      extend Dagnabit::Edge::Associations
      edge_for 'Vertex'     # sets up belongs_to associations called "parent" and "child"
    end

See the library documentation for details on methods provided by the
Connectivity modules.  Also see the listing of the `dagnabit-test` program.

Copyright
=========

Copyright (c) 2009-2010 David Yip.  Released under the MIT License; see LICENSE
for details.
