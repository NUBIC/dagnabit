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

      class CustomLink < ActiveRecord::Base
        set_table_name 'other_name_edges'
        acts_as_dag_link :ancestor_id_column => 'the_ancestor_id',
                         :descendant_id_column => 'the_descendant_id',
                         :transitive_closure_table_name => 'my_transitive_closure'
      end

      class CustomNode < ActiveRecord::Base
        set_table_name 'nodes'
        acts_as_dag_node_linked_by 'Dagnabit::Node::TestNeighbors::CustomLink',
          :neighbor_node_class_names => [ 'Dagnabit::Node::TestNeighbors::CustomNode' ]
      end

      def setup
        @n1 = Node.new
        @n2 = OtherNode.new
        @n3 = Node.new

        Link.connect(@n1, @n2)
        Link.connect(@n2, @n3)
      end

      should 'return all ancestors of the specified neighbor types' do
        ancestors = @n3.ancestors
        assert_equal 2, ancestors.length
        assert_equal Set.new([@n1, @n2]), Set.new(ancestors)
      end

      should 'return all descendants of the specified neighbor types' do
        descendants = @n1.descendants
        assert_equal 2, descendants.length
        assert_equal Set.new([@n2, @n3]), Set.new(descendants)
      end

      should 'return all ancestors of the specified neighbor types using customized links' do
        n1 = CustomNode.new
        n2 = CustomNode.new
        n3 = CustomNode.new

        CustomLink.connect(n1, n2)
        CustomLink.connect(n2, n3)

        ancestors = n3.ancestors
        assert_equal 2, ancestors.length
        assert_equal Set.new([n1, n2]), Set.new(ancestors)
      end

      should 'return all descendants of the specified neighbor types using customized links' do
        n1 = CustomNode.new
        n2 = CustomNode.new
        n3 = CustomNode.new

        CustomLink.connect(n1, n2)
        CustomLink.connect(n2, n3)

        descendants = n1.descendants
        assert_equal 2, descendants.length
        assert_equal Set.new([n2, n3]), Set.new(descendants)
      end
    end
  end
end
