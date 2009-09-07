require 'helper'

module Dagnabit
  module Link
    class TestCyclePrevention < ActiveRecord::TestCase
      should 'prevent simple cycles from being saved' do
        n1 = ::Node.create
        n2 = ::Node.create

        l1 = ::Link.create(:ancestor => n1, :descendant => n2)
        l2 = ::Link.create(:ancestor => n2, :descendant => n1)

        assert l2.new_record?
      end

      should 'prevent self-referential nodes' do
        n1 = ::Node.create

        l1 = ::Link.create(:ancestor => n1, :descendant => n1)
        assert l1.new_record?
      end

      should 'prevent cycles from being saved' do
        n1 = ::Node.create
        n2 = ::Node.create
        n3 = ::Node.create
        n4 = ::Node.create

        ::Link.create(:ancestor => n1, :descendant => n2)
        ::Link.create(:ancestor => n2, :descendant => n3)
        ::Link.create(:ancestor => n3, :descendant => n4)
        l = ::Link.create(:ancestor => n4, :descendant => n2)

        assert l.new_record?
      end

      should 'not prevent links from being saved multiple times in a row' do
        n1 = ::Node.create
        n2 = ::Node.create

        l = ::Link.new(:ancestor => n1, :descendant => n2)

        assert l.save
        assert l.save, 'should have been able to save twice'
      end

      should 'prevent cycles from being saved in customized links' do
        n1 = ::Node.create
        n2 = ::Node.create
        n3 = ::Node.create
        
        ::CustomizedLink.create(:ancestor => n1, :descendant => n2)
        ::CustomizedLink.create(:ancestor => n1, :descendant => n3)
        l3 = ::CustomizedLink.create(:ancestor => n3, :descendant => n1)
        
        assert l3.new_record?
      end

      should 'not execute on links that have no ancestor or descendant' do
        assert_nothing_raised { ::Link.create }
      end
    end
  end
end
