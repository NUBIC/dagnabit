require 'test_helper'

module Dagnabit
  module Link
    class TestConfiguration < ActiveRecord::TestCase
      should 'have default and settable names for transitive closure model and column names' do
        default_model = Class.new(ActiveRecord::Base) do
          set_table_name 'edges'

          acts_as_dag_link
        end

        custom_model = Class.new(ActiveRecord::Base) do
          set_table_name 'other_name_edges'

          acts_as_dag_link  :ancestor_id_column => 'the_ancestor_id',
                            :descendant_id_column => 'the_descendant_id',
                            :transitive_closure_table_name => 'my_transitive_closure',
                            :transitive_closure_class_name => 'MyTransitiveClosureLink'
        end

        assert_equal 'ancestor_id', default_model.ancestor_id_column
        assert_equal 'descendant_id', default_model.descendant_id_column
        assert_equal default_model.connection.quote_table_name('edges_transitive_closure_tuples'), default_model.transitive_closure_table_name
        assert_equal 'TransitiveClosureLink', default_model.transitive_closure_class_name

        assert_equal 'the_ancestor_id', custom_model.ancestor_id_column
        assert_equal 'the_descendant_id', custom_model.descendant_id_column
        assert_equal custom_model.connection.quote_table_name('my_transitive_closure'), custom_model.transitive_closure_table_name
        assert_equal 'MyTransitiveClosureLink', custom_model.transitive_closure_class_name
      end

      should 'not have its configuration accessors on ActiveRecord::Base' do
        assert !ActiveRecord::Base.respond_to?(:ancestor_id_column)
      end
    end
  end
end
