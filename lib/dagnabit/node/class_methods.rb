require 'ostruct'

module Dagnabit
  module Node
    module ClassMethods
      #
      # Returns a subgraph rooted at a given set of nodes.
      #
      # While you can retrieve all descendants of a node pretty easily (i.e.
      # +node.descendants+), and all links from a node really easily (i.e.
      # +node.links_as_ancestor), it's not quite as straightforward to get the
      # nodes and edges (direct edges, that is) out of a graph.
      #
      # The subgraph is returned as an object with two properties: +nodes+ and
      # +edges+.  Both properties are instances of the Set class.
      # 
      # == Examples
      #
      # In the following examples, the node class is called +Node+.  Variables
      # of the form +nM+, where M is an integer, denote Node instances.
      # 
      # Retrieve all descendants of n1 and all direct edges "underneath" n1
      # (i.e. n1 to its children and direct edges for each of n1's
      # descendants):
      #
      # <pre>
      # Node.subgraph_from(n1)
      #
      # => #<Graph nodes=... edges=...>
      # </pre>
      # 
      # Same as above, but builds a graph using n1 and n2 as roots.
      #
      # <pre>
      # Node.subgraph_from(n1, n2)
      # </pre>
      #
      # == Usage tip
      #
      # +subgraph_from+ forces loading of the +descendants+ and
      # +links_as_parent+ +links_as_parent+ associations on Node.  In some
      # situations, you may experience better performance if you use
      # ActiveRecord's eager-loading capabilities when using subgraph_from:
      #
      # <pre>
      # roots = Node.find(..., :include => [:descendants, :links_as_parent])
      # Node.subgraph_from(roots)
      # </pre>
      #
      def subgraph_from(*roots)
        returning(OpenStruct.new) do |g|
          g.nodes = all_nodes_of(roots)
          g.edges = direct_edges_of(roots)
        end
      end

      private

      def all_nodes_of(roots)
        roots.inject(Set.new) do |r, root|
          r += root.descendants
          r << root
        end
      end

      def direct_edges_of(roots)
        roots.inject(Set.new) do |r, root|
          r += root.links_as_ancestor.find(:all, :include => { :descendant => :links_as_parent }).map { |l| l.descendant.links_as_parent }.flatten
          r += root.links_as_parent
        end
      end
    end
  end
end
