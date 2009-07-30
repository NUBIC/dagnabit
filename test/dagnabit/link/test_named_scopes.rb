require 'helper'

module Dagnabit
  module Link
    class TestNamedScopes < ActiveRecord::TestCase
      class Link < ActiveRecord::Base
        set_table_name 'edges'
        acts_as_dag_link
      end

      class Node < ActiveRecord::Base
        set_table_name 'nodes'
        acts_as_dag_node_linked_by 'Dagnabit::Link::TestNamedScopes::Link',
          :neighbor_node_class_names => [ 'Dagnabit::Link::TestNamedScopes::Node',
                                          'Dagnabit::Link::TestNamedScopes::OtherNode']
      end

      class OtherNode < ActiveRecord::Base
        set_table_name 'nodes'
        acts_as_dag_node_linked_by 'Dagnabit::Link::TestNamedScopes::Link',
          :neighbor_node_class_names => [ 'Dagnabit::Link::TestNamedScopes::Node',
                                          'Dagnabit::Link::TestNamedScopes::OtherNode']
      end

      def setup
        @n1 = Node.new
        @n2 = OtherNode.new
        @n3 = Node.new

        @l1 = Link.build_edge(@n1, @n2)
        @l2 = Link.build_edge(@n2, @n3)
        @l1.save
        @l2.save
      end

      should 'scope links by ancestor type' do
        links = Link.ancestor_type(OtherNode.name)
        assert_equal [@l2], links
      end

      should 'scope links by descendant type' do
        links = Link.descendant_type(OtherNode.name)
        assert_equal [@l1], links
      end
    end
  end
end
