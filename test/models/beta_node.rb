class BetaNode < ActiveRecord::Base
  acts_as_dag_node_linked_by 'Link'
end
