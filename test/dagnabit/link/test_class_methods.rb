require 'test_helper'

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

      should 'add a class-level connect method to the link model' do
        n1 = Node.new
        n2 = Node.new

        Link.connect(n1, n2)
        link = Link.find(:first, :conditions => { :ancestor_id => n1.id, :descendant_id => n2.id })

        assert_not_nil link
        assert_equal n1, link.ancestor
        assert_equal n2, link.descendant
      end

      should 'add a class-level path? method to the link model'
    end
  end
end
