class Node < ActiveRecord::Base
  acts_as_dag_node_linked_by 'Link'
end
