require 'helper'

module Dagnabit
  module Link
    class TestClassMethods < ActiveRecord::TestCase
      should 'include a method to build edges' do
        n1 = ::Node.new
        n2 = ::Node.new

        link = ::Link.build_edge(n1, n2)
        assert_equal n1, link.ancestor
        assert_equal n2, link.descendant
      end

      should 'permit custom data to be included on edges' do
        n1 = ::Node.new
        n2 = ::Node.new

        link = CustomDataLink.build_edge(n1, n2, :data => 'foobar')
        assert_equal 'foobar', link.data
      end

      context 'connect' do
        should 'connect two nodes' do
          n1 = ::Node.new
          n2 = ::Node.new

          ::Link.connect(n1, n2)
          link = ::Link.find(:first, :conditions => { :ancestor_id => n1.id, :descendant_id => n2.id })

          assert_not_nil link
          assert_equal n1, link.ancestor
          assert_equal n2, link.descendant
        end

        should 'permit custom data to be included on edges' do
          n1 = ::Node.new
          n2 = ::Node.new

          CustomDataLink.connect(n1, n2, :data => 'foobar')
          link = CustomDataLink.find(:first, :conditions => { :ancestor_id => n1.id, :descendant_id => n2.id })

          assert_equal 'foobar', link.data
        end

        should 'return false if connection fails due to node invalidity' do
          n1 = ::Node.new
          n2 = ::Node.new

          n1.stubs(:valid?).returns(false)

          result = ::Link.connect(n1, n2)
          assert_equal false, result
        end

        should 'not save endpoints if connection fails due to node invalidity' do
          n1 = ::Node.new
          n2 = ::Node.new

          n1.stubs(:valid?).returns(false)

          ::Link.connect(n1, n2)

          assert n1.new_record?
          assert n2.new_record?
        end
      end

      context 'path?' do
        should 'return whether or not a path exists between two nodes' do
          n1 = ::Node.new
          n2 = ::Node.new
          n3 = ::Node.new
          n4 = ::Node.new

          ::Link.connect(n1, n2)
          ::Link.connect(n2, n3)

          assert ::Link.path?(n1, n2)
          assert ::Link.path?(n1, n3)
          assert !::Link.path?(n1, n4)
        end
      end

      context 'paths' do
        should 'return all paths between two nodes' do
          n1 = ::Node.new
          n2 = ::Node.new
          n3 = ::Node.new

          ::Link.connect(n1, n2)
          ::Link.connect(n2, n3)

          paths = ::Link.paths(n1, n3)
          assert_equal 1, paths.length
          assert_equal n1, paths.first.ancestor
          assert_equal n3, paths.first.descendant
        end
      end
    end
  end
end
