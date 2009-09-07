class CustomizedLink < ActiveRecord::Base
  set_table_name 'other_name_edges'

  acts_as_dag_link :ancestor_id_column => 'the_ancestor_id',
                   :descendant_id_column => 'the_descendant_id',
                   :transitive_closure_table_name => 'my_transitive_closure'
end
