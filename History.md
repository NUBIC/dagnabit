3.0.1 (2011-04-30)
==================

Minor changes
-------------

* Declare compatibility with ActiveRecord 3.
* Eagerly load parent and child associations for edges loaded by
  `Dagnabit::Graph#load_descendants!`.
* Loosened up RSpec dependency.

3.0.0 2011-01-10
================

Major changes
-------------

* Completely new data model: no more post-insert processing, no more transitive
  closure table.  Downside: only PostgreSQL is presently supported.

2.2.6 2010-01-01
================

Bugfixes
--------

* Fixed version requirements.

2.2.5 2010-10-01
================

Minor changes
-------------

* Ported development code to Bundler 1.0.
* Removed usage of `Object#returning`, which was deprecated in ActiveSupport
  2.3.9.

2.2.4 2010-03-15
================

Bugfixes
--------

* Ensure that ActiveRecord is loaded before dagnabit's extensions are loaded.
  This fixes a problem that would occasionally occur when using dagnabit in
  Bundler.

2.2.3 2010-02-17
================

Bugfixes
--------

* It was not possible to delete links having custom data attributes in dagnabit
  versions <= 2.3.2.  This has been fixed.

2.2.2 2010-02-04
================

Minor enhancements
------------------

* Slightly smarter transitive closure maintenance: if a link was saved but
  neither its ancestor nor descendant changed, the transitive closure will not
  be recalculated.
* Removed usage of deprecated `require 'activesupport'`.

2.2.1 2009-12-07
================

Minor enhancements
------------------

* Added NUBIC provenance.

2.2.0 2009-09-14
================

Minor enhancements
------------------

* Commonized models used in dagnabit's tests.
* Switched to named scopes to implement Link#linking and TransitiveClosureLink#linking.

2.1.0 2009-09-04
================

Bugfixes
--------

* Fixed overzealous on-destroy transitive closure maintenance in situations like these:
 
  <pre>
  n1 -> n2 -> n3
   |__________|
  </pre>

  Previously, deleting the edges (n1, n2) and (n2, n3) would also delete the
  edge (n1, n3).

2.0.0 2009-08-17
================

Major changes
-------------

* Link models now validate their ancestor and descendant.  This means that
  Link#connect will fail if a link cannot be made due to node validation
  failures.

  Unfortunately, this also means you can no longer write (say)
  `node1.links_as_parent.build(:descendant => node2)` or
  `node2.links_as_child.build(:ancestor => node1)`.

  See commit `61d6e3841b63fdcaad7fcecd05b24f4b9f217ba2` for more details.
