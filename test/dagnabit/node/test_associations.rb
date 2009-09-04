require 'helper'

module Dagnabit
  module Node
    class TestAssociations < ActiveRecord::TestCase
      class Link < ActiveRecord::Base
        set_table_name 'edges'
        acts_as_dag_link
      end

      class Node < ActiveRecord::Base
        set_table_name 'nodes'
        acts_as_dag_node_linked_by 'Dagnabit::Node::TestAssociations::Link'
      end

      class BetaNode < ActiveRecord::Base
        set_table_name 'beta_nodes'
        acts_as_dag_node_linked_by 'Dagnabit::Node::TestAssociations::Link'
      end

      class OtherLink < ActiveRecord::Base
        set_table_name 'edges'
        acts_as_dag_link
      end

      class OtherNode < ActiveRecord::Base
        set_table_name 'nodes'
        acts_as_dag_node_linked_by 'Dagnabit::Node::TestAssociations::OtherLink'
      end

      class OtherTableLink < ActiveRecord::Base
        set_table_name 'other_name_edges'
        acts_as_dag_link :ancestor_id_column => 'the_ancestor_id',
                         :descendant_id_column => 'the_descendant_id',
                         :transitive_closure_table_name => 'my_transitive_closure'
      end

      class OtherTableNode < ActiveRecord::Base
        set_table_name 'nodes'
        acts_as_dag_node_linked_by 'Dagnabit::Node::TestAssociations::OtherTableLink'
      end

      class BaseNode < ActiveRecord::Base
        self.abstract_class = true
        set_table_name 'nodes'
        acts_as_dag_node_linked_by 'Dagnabit::Node::TestAssociations::Link'
      end

      class DerivedNode < BaseNode
      end

      def setup
        @n1 = Node.new
        @n2 = Node.new
        @n3 = Node.new
      end

      should 'report links for which the node is a child' do
        Link.connect(@n1, @n2)

        assert_equal 1, @n2.links_as_child.count
        assert_equal @n1, @n2.links_as_child.first.ancestor
      end

      should 'report links for which the node is a child, using a different link model' do
        n1 = OtherNode.new
        n2 = OtherNode.new

        OtherLink.connect(n1, n2)

        assert_equal 1, n2.links_as_child.count
        assert_equal n1, n2.links_as_child.first.ancestor

        assert n2.links_as_child.first.is_a?(OtherLink), 'expected OtherLink'
      end

      should 'report links for which the node is a child, using a different link model and different foreign key' do
        n1 = OtherTableNode.new
        n2 = OtherTableNode.new

        OtherTableLink.connect(n1, n2)

        assert_equal 1, n2.links_as_child.count
        assert_equal n1, n2.links_as_child.first.ancestor

        assert n2.links_as_child.first.is_a?(OtherTableLink), 'expected OtherTableLink'
      end

      should 'report links for which the node is a parent' do
        Link.connect(@n1, @n2)

        assert_equal 1, @n1.links_as_parent.count
        assert_equal @n2, @n1.links_as_parent.first.descendant
      end

      should 'report links for which the node is an ancestor' do
        Link.connect(@n1, @n2)
        Link.connect(@n1, @n3)

        assert_equal 2, @n1.links_as_ancestor.count
        assert_equal Set.new([@n2, @n3]), Set.new(@n1.links_as_ancestor.map(&:descendant))
      end

      should 'report links for which the node is a descendant' do
        Link.connect(@n1, @n2)
        Link.connect(@n2, @n3)

        assert_equal 2, @n3.links_as_descendant.count
        assert_equal Set.new([@n1, @n2]), Set.new(@n3.links_as_descendant.map(&:ancestor))
      end

      should 'clean up links to parents and children when destroyed' do
        n1 = Node.new
        n2 = Node.new
        n3 = Node.new

        Link.connect(n1, n2)
        Link.connect(n2, n3)
        Link.connect(n1, n3)

        n2.destroy

        assert_equal [n3], n1.children
        assert_equal [n3], n1.descendants
        assert_equal [n1], n3.ancestors
        assert_equal [n1], n3.parents
      end

      should 'report links for which the node is a parent on derived nodes' do
        n1 = DerivedNode.new
        n2 = DerivedNode.new

        Link.connect(n1, n2)

        assert_equal [n2], n1.links_as_parent.map(&:descendant)
      end

      context 'node class scoping' do
        setup do
          @n1 = Node.new
          @n2a = BetaNode.new
          @n2b = BetaNode.new
          @n3 = Node.new

          Link.connect(@n1, @n2a)
          Link.connect(@n1, @n2b)
          Link.connect(@n2a, @n3)
          Link.connect(@n2b, @n3)
        end

        should 'apply to parent links' do
          assert_equal 2, @n1.links_as_parent.length
        end

        should 'apply to child links' do
          assert_equal 2, @n3.links_as_child.length
        end

        should 'apply to ancestor links' do
          # We expect three links here:
          # n1 -> n2a
          # n1 -> n2b
          # n1 -> n3
          assert_equal 3, @n1.links_as_ancestor.length
        end

        should 'apply to descendant links' do
          # Similar logic here.
          assert_equal 3, @n3.links_as_descendant.length
        end
      end
    end
  end
end
