class CustomizedLinkNode < ActiveRecord::Base
  set_table_name 'nodes'
  acts_as_dag_node_linked_by '::CustomizedLink'
end
