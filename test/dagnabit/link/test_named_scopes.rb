require 'helper'

module Dagnabit
  module Link
    class TestNamedScopes < ActiveRecord::TestCase
      class OtherNode < ActiveRecord::Base
        set_table_name 'nodes'
      end

      def setup
        @n1 = ::Node.new
        @n2 = OtherNode.new
        @n3 = ::Node.new

        @l1 = ::Link.build_edge(@n1, @n2)
        @l2 = ::Link.build_edge(@n2, @n3)
        @l1.save
        @l2.save
      end

      should 'scope links by ancestor type' do
        links = ::Link.ancestor_type(OtherNode.name)
        assert_equal [@l2], links
      end

      should 'scope links by descendant type' do
        links = ::Link.descendant_type(OtherNode.name)
        assert_equal [@l1], links
      end
    end
  end
end
