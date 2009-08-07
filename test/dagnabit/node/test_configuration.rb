require 'helper'

module Dagnabit
  module Node
    class TestConfiguration < ActiveRecord::TestCase
      def setup
        @node_model = Class.new(ActiveRecord::Base) do
          set_table_name 'nodes'

          extend Dagnabit::Node::Configuration
        end
      end

      should 'accept the name of a link class' do
        @node_model.configure_acts_as_dag_node('Link')

        assert_equal 'Link', @node_model.link_class_name
      end

      should 'be inheritable' do
        @node_model.configure_acts_as_dag_node('Link')

        subclassed_model = Class.new(@node_model)

        assert_equal 'Link', subclassed_model.link_class_name
      end
    end
  end
end
