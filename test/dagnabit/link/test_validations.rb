require 'helper'

module Dagnabit
  module Link
    class TestValidations < ActiveRecord::TestCase
      class Node < ActiveRecord::Base
        set_table_name 'nodes'
      end

      class Link < ActiveRecord::Base
        set_table_name 'edges'
        extend Dagnabit::Link::Configuration
        configure_acts_as_dag_link({})
        extend Dagnabit::Link::Associations
        extend Dagnabit::Link::Validations
      end

      def setup
        @n1 = Node.new
        @n2 = Node.new
        @link = Link.new
      end

      should 'not permit a null ancestor' do
        @link.ancestor = nil
        assert !@link.save
      end

      should 'not permit a null descendant' do
        @link.descendant = nil
        assert !@link.save
      end
    end
  end
end
