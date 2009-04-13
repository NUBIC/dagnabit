require 'test_helper'

module Dagnabit
  class TestActivation < ActiveRecord::TestCase
    def setup
      @edge_class = Class.new(ActiveRecord::Base) do
        set_table_name 'edges'
        acts_as_dag_link
      end
    end

    should 'add a class-level connect method to the edge model' do
      assert @edge_class.respond_to?(:connect)
    end

    should 'add a class-level connect! method to the edge model' do
      assert @edge_class.respond_to?(:connect!)
    end
    
    should 'add a class-level path? method to the edge model' do
      assert @edge_class.respond_to?(:path?)
    end

    should 'add a class-level paths method to the edge model' do
      assert @edge_class.respond_to?(:paths)
    end
  end
end
