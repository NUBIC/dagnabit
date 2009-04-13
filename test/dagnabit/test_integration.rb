require 'test_helper'

module Dagnabit
  module Edge
    class TestIntegration < ActiveRecord::TestCase
      def setup
        @edge_class = Class.new(ActiveRecord::Base) do
          set_table_name 'edges'
          acts_as_dag_link
        end

        @node_class = Class.new(ActiveRecord::Base) do
          set_table_name 'nodes'
          acts_as_dag_node
        end
      end
    end
  end
end
