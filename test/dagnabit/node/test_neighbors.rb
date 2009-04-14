require 'test_helper'

module Dagnabit
  module Node
    class TestNeighbors < ActiveRecord::TestCase
      class Link < ActiveRecord::Base
        set_table_name 'edges'
        acts_as_dag_link
      end

      class Node < ActiveRecord::Base
        set_table_name 'nodes'
        acts_as_dag_node_linked_by 'Dagnabit::Node::TestNeighbors::Link',
          :neighbor_node_class_names => [ 'Dagnabit::Node::TestNeighbors::Node',
                                          'Dagnabit::Node::TestNeighbors::OtherNode']
      end

      class OtherNode < ActiveRecord::Base
        set_table_name 'nodes'
        acts_as_dag_node_linked_by 'Dagnabit::Node::TestNeighbors::Link',
          :neighbor_node_class_names => [ 'Dagnabit::Node::TestNeighbors::Node',
                                          'Dagnabit::Node::TestNeighbors::OtherNode']
      end

      def setup
        @n1 = Node.new
        @n2 = OtherNode.new
        @n3 = Node.new

        Link.connect(@n1, @n2)
        Link.connect(@n2, @n3)
      end

      should 'return all ancestors of the specified neighbor types' do
        assert_equal Set.new([@n1, @n2]), Set.new(@n3.ancestors)
      end

      should 'return all descendants of the specified neighbor types' do
        assert_equal Set.new([@n2, @n3]), Set.new(@n1.descendants)
      end
    end
  end
end
