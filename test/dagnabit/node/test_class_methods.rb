require 'helper'

module Dagnabit
  module Node
    class TestClassMethods < ActiveRecord::TestCase
      class Link < ActiveRecord::Base
        set_table_name 'edges'
        acts_as_dag_link
      end

      class Node < ActiveRecord::Base
        set_table_name 'nodes'
        acts_as_dag_node_linked_by 'Dagnabit::Node::TestClassMethods::Link'
      end
      
      def setup
        #
        # Structure:
        #
        #    -- n1 
        #   /      \
        # n0        n3 -- n4
        #   \-- n2 /
        #
        @links = []
        @ns = (1..5).map { Node.new }

        [ [@ns[0], @ns[1]],
          [@ns[0], @ns[2]],
          [@ns[1], @ns[3]],
          [@ns[2], @ns[3]],
          [@ns[3], @ns[4]] ].each do |ancestor, descendant|
            @links << Link.new(:ancestor => ancestor, :descendant => descendant)
          end

        @ns.each { |n| n.save }
        @links.each { |l| l.save }
        @root = @ns[0]
      end

      should 'allow retrieval of subgraphs rooted at a given node' do
        graph = Node.subgraph_from(@root)

        assert_equal Set.new(@ns), graph.nodes
        assert_equal Set.new(@links), graph.edges
      end

      should 'allow retrieval of subgraphs rooted at multiple nodes' do
        graph = Node.subgraph_from(@ns[1], @ns[2])

        # expect n0 to not be present
        assert_equal Set.new(@ns[1..4]), graph.nodes

        # expect (n0, n1) and (n0, n2) to not be present
        assert_equal Set.new(@links[2..-1]), graph.edges
      end
    end
  end
end
