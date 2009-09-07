require 'helper'

module Dagnabit
  module Link
    class TestTransitiveClosureLinkModel < ActiveRecord::TestCase
      def setup
        @model = ::Link::TransitiveClosureLink.new
        @model.class.set_table_name 'edges_transitive_closure_tuples'
        @node = ::Node.new
      end

      should 'belong to an ancestor' do
        @model.ancestor = @node
        @model.save

        @model = ::Link::TransitiveClosureLink.find(@model.id)
        assert_equal @node, @model.ancestor
      end

      should 'belong to a descendant' do
        @model.descendant = @node
        @model.save

        @model = ::Link::TransitiveClosureLink.find(@model.id)
        assert_equal @node, @model.descendant
      end

      # TODO: wrap tests in transaction
      should 'support find(:all) queries including associations' do
        ::Link::TransitiveClosureLink.delete_all

        n1 = ::Node.new
        n2 = ::Node.new
        ::Link::TransitiveClosureLink.create(:ancestor => n1, :descendant => n2)

        links = ::Link::TransitiveClosureLink.find(:all, :include => :ancestor)
        assert_equal 1, links.length
      end

      should 'support scoping by ancestor type' do
        ::Link::TransitiveClosureLink.delete_all

        n1 = ::BetaNode.new
        n2 = ::Node.new

        ::Link::TransitiveClosureLink.create(:ancestor => n1, :descendant => n2)

        links = ::Link::TransitiveClosureLink.ancestor_type(::BetaNode.name)

        assert_equal 1, links.length
        assert_equal n1, links.first.ancestor
      end

      should 'support scoping by descendant type' do
        ::Link::TransitiveClosureLink.delete_all

        n1 = ::Node.new
        n2 = ::BetaNode.new

        ::Link::TransitiveClosureLink.create(:ancestor => n1, :descendant => n2)

        links = ::Link::TransitiveClosureLink.descendant_type(::BetaNode.name)

        assert_equal 1, links.length
        assert_equal n2, links.first.descendant
      end
    end
  end
end
