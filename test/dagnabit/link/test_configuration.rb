require 'test_helper'

module Dagnabit
  module Link
    class TestConfiguration < ActiveRecord::TestCase
      should 'have default and settable names for transitive closure table and column names' do
        default_model = Class.new(ActiveRecord::Base) do
          set_table_name 'edges'

          acts_as_dag_link
        end

        custom_model = Class.new(ActiveRecord::Base) do
          set_table_name 'other_name_edges'

          acts_as_dag_link  :ancestor_id_column => 'the_ancestor_id',
                            :descendant_id_column => 'the_descendant_id',
                            :ancestor_type_column => 'the_ancestor_type',
                            :descendant_type_column => 'the_descendant_type',
                            :transitive_closure_table_name => 'my_transitive_closure'
        end

        assert_equal 'ancestor_id', default_model.ancestor_id_column
        assert_equal 'descendant_id', default_model.descendant_id_column
        assert_equal 'ancestor_type', default_model.ancestor_type_column
        assert_equal 'descendant_type', default_model.descendant_type_column
        assert_equal 'edges_transitive_closure_tuples', default_model.transitive_closure_table_name

        assert_equal 'the_ancestor_id', custom_model.ancestor_id_column
        assert_equal 'the_descendant_id', custom_model.descendant_id_column
        assert_equal 'the_ancestor_type', custom_model.ancestor_type_column
        assert_equal 'the_descendant_type', custom_model.descendant_type_column
        assert_equal 'my_transitive_closure', custom_model.transitive_closure_table_name
      end

      should 'not have its configuration accessors on ActiveRecord::Base' do
        assert !ActiveRecord::Base.respond_to?(:ancestor_id_column)
      end
    end
  end
end
