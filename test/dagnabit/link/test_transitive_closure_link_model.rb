require 'test_helper'

module Dagnabit
  module Link
    class TestTransitiveClosureLinkModel < ActiveRecord::TestCase
      class Node < ActiveRecord::Base
        set_table_name 'nodes'
      end

      class Link < ActiveRecord::Base
        set_table_name 'edges'
        acts_as_dag_link
      end

      def setup
        @model = Link::TransitiveClosureLink.new
        @model.class.set_table_name 'edges_transitive_closure_tuples'
        @node = Node.new
      end

      should 'belong to an ancestor' do
        @model.ancestor = @node
        @model.save

        @model = Link::TransitiveClosureLink.find(@model.id)
        assert_equal @node, @model.ancestor
      end

      should 'belong to a descendant' do
        @model.descendant = @node
        @model.save

        @model = Link::TransitiveClosureLink.find(@model.id)
        assert_equal @node, @model.descendant
      end
    end
  end
end
