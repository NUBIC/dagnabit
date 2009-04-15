require 'helper'

module Dagnabit
  module Link
    class TestClassMethods < ActiveRecord::TestCase
      class Node < ActiveRecord::Base
        set_table_name 'nodes'
      end

      class Link < ActiveRecord::Base
        set_table_name 'edges'
        acts_as_dag_link
      end

      should 'include a method to build edges' do
        n1 = Node.new
        n2 = Node.new

        link = Link.build_edge(n1, n2)
        assert_equal n1, link.ancestor
        assert_equal n2, link.descendant
      end

      context 'connect' do
        should 'connect two nodes' do
          n1 = Node.new
          n2 = Node.new

          Link.connect(n1, n2)
          link = Link.find(:first, :conditions => { :ancestor_id => n1.id, :descendant_id => n2.id })

          assert_not_nil link
          assert_equal n1, link.ancestor
          assert_equal n2, link.descendant
        end
      end

      context 'path?' do
        should 'return whether or not a path exists between two nodes' do
          n1 = Node.new
          n2 = Node.new
          n3 = Node.new
          n4 = Node.new

          Link.connect(n1, n2)
          Link.connect(n2, n3)

          assert Link.path?(n1, n2)
          assert Link.path?(n1, n3)
          assert !Link.path?(n1, n4)
        end
      end

      context 'paths' do
        should 'return all paths between two nodes' do
          n1 = Node.new
          n2 = Node.new
          n3 = Node.new

          Link.connect(n1, n2)
          Link.connect(n2, n3)

          paths = Link.paths(n1, n3)
          assert_equal 1, paths.length
          assert_equal n1, paths.first.ancestor
          assert_equal n3, paths.first.descendant
        end
      end
    end
  end
end
