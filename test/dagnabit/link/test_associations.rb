require 'test_helper'

module Dagnabit
  module Link
    class TestAssociations < ActiveRecord::TestCase
      class Node < ActiveRecord::Base
        set_table_name 'nodes'
      end

      class Link < ActiveRecord::Base
        set_table_name 'edges'
        acts_as_dag_link
      end

      class CustomLink < ActiveRecord::Base
        set_table_name 'other_name_edges'
        acts_as_dag_link :ancestor_id_column => 'the_ancestor_id',
                         :descendant_id_column => 'the_descendant_id',
                         :transitive_closure_table_name => 'my_transitive_closure'
      end

      def setup
        @node = Node.new
        @link = Link.new
        @custom_link = CustomLink.new
      end

      should 'add an ancestor association proxy' do
        @link.ancestor = @node
        @link.save
        assert_equal @node, @link.reload.ancestor
      end

      should 'add a descendant association proxy' do
        @link.descendant = @node
        @link.save
        assert_equal @node, @link.reload.descendant
      end

      should 'permit customization of the ancestor association foreign key' do
        @custom_link.ancestor = @node
        @custom_link.save
        @custom_link = CustomLink.find(@custom_link.id)
        assert_equal @node, @custom_link.ancestor
      end

      should 'permit customization of the descendant association foreign key' do
        @custom_link.descendant = @node
        @custom_link.save
        @custom_link = CustomLink.find(@custom_link.id)
        assert_equal @node, @custom_link.descendant
      end
    end
  end
end
