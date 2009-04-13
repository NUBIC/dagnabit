require 'test_helper'

module Dagnabit
  module Link
    class TestCyclePrevention < ActiveRecord::TestCase
      class Node < ActiveRecord::Base
        set_table_name 'nodes'
      end

      class Link < ActiveRecord::Base
        set_table_name 'edges'
        acts_as_dag_link
      end

      should 'prevent simple cycles from being saved' do
        n1 = Node.create
        n2 = Node.create

        l1 = Link.create(:ancestor => n1, :descendant => n2)
        l2 = Link.create(:ancestor => n2, :descendant => n1)

        assert l2.new_record?
      end

      should 'prevent cycles from being saved'
    end
  end
end
