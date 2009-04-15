require 'helper'

module Dagnabit
  module Node
    class TestConfiguration < ActiveRecord::TestCase
      should 'accept the name of a link class' do
        default_model = Class.new(ActiveRecord::Base) do
          set_table_name 'nodes'

          extend Dagnabit::Node::Configuration
          configure_acts_as_dag_node('Link')
        end

        assert_equal 'Link', default_model.link_class_name
      end

      should 'accept names of neighbor node classes' do
        default_model = Class.new(ActiveRecord::Base) do
          set_table_name 'nodes'

          extend Dagnabit::Node::Configuration
          configure_acts_as_dag_node('Link', :neighbor_node_class_names => ['Node'])
        end

        assert_equal ['Node'], default_model.neighbor_node_class_names
      end
    end
  end
end
